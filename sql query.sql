select al.title album,t.name trackname, ar.name artist ,t.composer , g.name genre ,t.unitprice  
from Track t
join genre g  on g.genreid = t.genreid
join album al on al.albumid = t.albumid
join artist ar on ar.artistid = al.artistid;

select al.title album, ar.name artist , g.name genre , sum(t.unitprice) totalprice 
from Track t
join genre g  on g.genreid = t.genreid
join album al on al.albumid = t.albumid
join artist ar on ar.artistid = al.artistid
group by al.title , ar.name  , g.name 





