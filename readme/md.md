# PAGE
space is divided into pages  
Each page within a space is assigned a 32-bit integer page number, often called “offset”,  
which is actually just the page’s offset from the beginning of the space (not necessarily the file, for multi-file spaces).  
So, page 0 is located at file offset 0, page 1 at file offset 16384, and so on.  
  một số lệnh để thấy page:
    innodb_space -f /var/lib/mysql/test/t.ibd -p 3 page-dump
      chứa FIL header (and footer)
      Dựa vào page type khác nhau thì
        chứa “page header”, information about the index page
        chứa “fseg header”, information related to space management for the file segments (groups of extents) used by this index
        a summary of sizes (in bytes) of different parts of the page: free space, data space, record size, etc.
        chứa system records, infimum and supremum
        chứa contents of the page directory, which is used to make record searches more efficient
        chứa user records, the actual data stored by the user (the fields of which will not be parsed unless a record “describer” has been loaded)

Space files:
A space file is just a concatenation of many (up to 232) pages.  
InnoDB needs to do some bookkeeping to keep track of all of the pages, extents, and the space itself, so a space file has some mandatory super-structure  
  một số lệnh để thấy space:
    innodb_space -f /var/lib/mysql/ibdata1 space-page-type-regions
    innodb_space -f /var/lib/mysql/test/t.ibd space-page-type-regions
      chứa first page (page 0) in a space is always an FSP_HDR or “file space header"
      chứa FSP_HDR
      An FSP_HDR page only has enough space internally to store bookkeeping information for 256 extents (or 16,384 pages, 256 MiB), so additional space must be reserved every 16,384 pages for bookkeeping information in the form of an XDES page. The structure of XDES and FSP_HDR pages is identical, except that the FSP header structure is zeroed-out in XDES pages.
      chứa INODE
      chứa Alongside each FSP_HDR or XDES page will also be an IBUF_BITMAP page
The system space (space 0):
  Page 4, type INDEX: The root page of the index structure used for insert buffering.  
Per-table space files:  
  Ignoring “fast index creation” which adds indexes at runtime, after the requisite 3 initial pages, the next pages (page 2) allocated in the space will be the root pages of each index in the table, in the order they were defined in the table creation. Page 3 will be the root of the clustered index, Page 4 will be the root of the first secondary key, etc.
  
Since most of InnoDB’s bookkeeping structures are stored in the system space, most pages allocated in a per-table space will be of type INDEX and store table data.  

# Page Management In Innodb space-files  
free space management within InnoDB: extent descriptors, file segments (inodes), and lists.  
## FSP_HDR and XDES pages:
```
innodb_space -f /var/lib/mysql/test/t.ibd -p 0 page-dump | head -n 200
innodb_space -f /var/lib/mysql/employees/departments.ibd -p 0 page-dump | grep "#<Innodb::Xdes:0x"

innodb_space -f /var/lib/mysql/employees/departments.ibd -p 0 page-dump | grep "#<Innodb::Xdes:0x" | wc -l
256

150, 190 là thứ tự byte trong ảnh luôn
Cách 40 byte là sang Innodb::Page::Address mới

xdes entries:
#<Innodb::Xdes:0x0000561f5c913580
 @page=
  #<Innodb::Page::FspHdrXdes size=16384, space_id=6, offset=0, type=:FSP_HDR, prev=0, next=0, checksum_valid?=true, checksum_type=:crc32, torn?=false, misplaced?=false>,
 @xdes=
  #<struct Innodb::Xdes::Entry
   offset=150,
   start_page=0,
   end_page=63,
   fseg_id=0,
   this=#<struct Innodb::Page::Address page=0, offset=158>,
   list=#<struct Innodb::List::Node prev=nil, next=nil>,
   state=:free_frag,
   bitmap="\xAA\xFE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF">>
#<Innodb::Xdes:0x0000561f5c8ea3b0
 @page=
  #<Innodb::Page::FspHdrXdes size=16384, space_id=6, offset=0, type=:FSP_HDR, prev=0, next=0, checksum_valid?=true, checksum_type=:crc32, torn?=false, misplaced?=false>,
 @xdes=
  #<struct Innodb::Xdes::Entry
   offset=190,
   start_page=64,
   end_page=127,
   fseg_id=0,
   this=#<struct Innodb::Page::Address page=0, offset=198>,
   list=
    #<struct Innodb::List::Node
     prev=#<struct Innodb::Page::Address page=0, offset=0>,
     next=#<struct Innodb::Page::Address page=0, offset=0>>,
   state=nil,
   bitmap="\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00">>
#<Innodb::Xdes:0x0000561f5c95e288
 @page=
  #<Innodb::Page::FspHdrXdes size=16384, space_id=6, offset=0, type=:FSP_HDR, prev=0, next=0, checksum_valid?=true, checksum_type=:crc32, torn?=false, misplaced?=false>,
 @xdes=
  #<struct Innodb::Xdes::Entry
   offset=230,
   start_page=128,
   end_page=191,
   fseg_id=0,
   this=#<struct Innodb::Page::Address page=0, offset=238>,
   list=
    #<struct Innodb::List::Node
     prev=#<struct Innodb::Page::Address page=0, offset=0>,
     next=#<struct Innodb::Page::Address page=0, offset=0>>,
   state=nil,
   bitmap="\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00">>
#<Innodb::Xdes:0x0000561f5c995fa8
 @page=
  #<Innodb::Page::FspHdrXdes size=16384, space_id=6, offset=0, type=:FSP_HDR, prev=0, next=0, checksum_valid?=true, checksum_type=:crc32, torn?=false, misplaced?=false>,
 @xdes=
  #<struct Innodb::Xdes::Entry
   offset=270,
   start_page=192,
   end_page=255,
   fseg_id=0,
   this=#<struct Innodb::Page::Address page=0, offset=278>,
   list=
    #<struct Innodb::List::Node
     prev=#<struct Innodb::Page::Address page=0, offset=0>,
     next=#<struct Innodb::Page::Address page=0, offset=0>>,
   state=nil,
   bitmap="\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00">>
```
FSP_HDR and XDES pages: fixed locations within the space, to keep track of which extents are in use, and which pages within each extent are in use



Một page bất kỳ (FSP_HDR cũng khong ngoại lệ) thì có FIL header  
Một page FSP_HDR có FIL header and trailer, an FSP header (có chức năng), and 256 “extent descriptors”.  
extent descriptor = XDES Entry (gồm File Segment ID, Pointers to previous and next extents, FREE, FREE_FRAG, and FULL_FRAG...)  

An “extent” - 1 MiB blocks of 64 contiguous 16 KiB InnoDB pages.  
64 contiguous InnoDB pages ==> 1 Entent ==> Space = hơn 256 Extents (A.idb)  
64 contiguous InnoDB pages ==> 1 XDES Entry (1 List note: prev, next) ==> XDES page = 256 XDES Entry   
offset=150,  
start_page=0,  
end_page=63,  

offset=270 - page(offset=270)=192
page_16384(offset=270)= 16384 + 192 = 16576

  Chắc chắn sẽ có: FSEG header  
  index’s FSEG header contains pointers to the file segment INODE entries which describe the file segments used by the index  
  index uses one file segment for leaf pages and one for non-leaf (internal) pages  
## INODE
Each INODE page contains 85 file segment INODE entries (for a 16 KiB page), each of which are 192 bytes. In addition, they contain a list node which is used in the following lists of INODE pages in the FSP_HDR‘s FSP header structure as described above  
innodb_space -f /var/lib/mysql/employees/departments.ibd -p 2 page-dump | head -n 200  
inodes:
  #<struct Innodb::Inode::Header
 offset=242,
 fseg_id=2,
 not_full_n_used=0,
 free=
  #<Innodb::List::Xdes:0x000055c3399c81a8
   @base=#<struct Innodb::List::BaseNode length=0, first=nil, last=nil>,
   @space=
    <Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>>,
 not_full=
  #<Innodb::List::Xdes:0x000055c3399d2bf8
   @base=#<struct Innodb::List::BaseNode length=0, first=nil, last=nil>,
   @space=
    <Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>>,
 full=
  #<Innodb::List::Xdes:0x000055c3399d1668
   @base=#<struct Innodb::List::BaseNode length=0, first=nil, last=nil>,
   @space=
    <Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>>,
 magic_n=97937874,
 frag_array=
  [nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil]>
#<struct Innodb::Inode::Header
 offset=434,
 fseg_id=3,
 not_full_n_used=0,
 free=
  #<Innodb::List::Xdes:0x000055c339a01610
   @base=#<struct Innodb::List::BaseNode length=0, first=nil, last=nil>,
   @space=
    <Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>>,
 not_full=
  #<Innodb::List::Xdes:0x000055c339a00080
   @base=#<struct Innodb::List::BaseNode length=0, first=nil, last=nil>,
   @space=
    <Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>>,
 full=
  #<Innodb::List::Xdes:0x000055c339a0aad0
   @base=#<struct Innodb::List::BaseNode length=0, first=nil, last=nil>,
   @space=
    <Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>>,
 magic_n=97937874,
 frag_array=
  [4,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil,
   nil]>
  
## INDEX PAGE
FSEG header  
innodb_space -f /var/lib/mysql/employees/departments.ibd -p 3 page-dump | head -n 200  
fseg header:
#<struct Innodb::Page::Index::FsegHeader
 leaf=
  <Innodb::Inode space=<Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>, fseg=2>,
 internal=
  <Innodb::Inode space=<Innodb::Space file="employees/departments.ibd", page_size=16384, pages=5>, fseg=1>>

Each index uses one file segment for leaf pages  
Each index uses one file segment for non-leaf (internal) pages  

# Physical structure of InnoDB index pages
  
  
# B+Tree index structures

# Physical structure of records

# Efficiently traversing InnoDB B+Trees with the page directory

# InnoDB behave without a Primary Key
