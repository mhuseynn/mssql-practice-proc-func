--1. Write a function that returns a list of books with the minimum number of pages issued by a particular publisher.
--1. Müəyyən Publisher tərəfindən çap olunmuş minimum səhifəli kitabların siyahısını çıxaran funksiya yazın

CREATE FUNCTION GetPress
(
    @publisherName NVARCHAR(255)
)
RETURNS TABLE
AS
RETURN
(
    SELECT min(Books.Pages) as MINPage,Press.[Name] FROM Books
    inner join Press on Press.Id=Books.Id_Press
    group by Press.[Name]
    Having Press.[Name] = @publisherName

)

Select * from GetPress('Binom')


--2. Write a function that returns the names of publishers who have published books with an average number of pages greater than N. The average number of pages is passed through the parameter.
--2. Orta səhifə sayı N-dən çox səhifəli kitab çap edən Publisherlərin adını qaytaran funksiya yazın. N parameter olaraq göndərilir.

create FUNCTION avgpage
(
    @count bigint
)
RETURNS Table
Return
	SELECT avg(Books.Pages) as 'Avg',Press.[Name] FROM Books
    inner join Press on Press.Id=Books.Id_Press
    group by Press.[Name]
    Having avg(Books.Pages) > @count

select * from avgpage(224)


--3. Write a function that returns the total sum of the pages of all the books in the library issued by the specified publisher.
--3. Müəyyən Publisher tərəfindən çap edilmiş bütün kitab səhifələrinin cəmini tapan və qaytaran funksiya yazın.

create FUNCTION GetSumPages
(
    @publisherName NVARCHAR(255)
)
RETURNS int
AS
Begin
	
    declare @sum int
	SELECT @sum=sum(Books.Pages) FROM Books
    inner join Press on Press.Id=Books.Id_Press
    group by Press.[Name]
    Having Press.[Name] = @publisherName

	return @sum

End

print dbo.GetSumPages('Binom')

--4. Write a function that returns a list of names and surnames of all students who took books between the two specified dates.
--4. Müəyyən iki tarix aralığında kitab götürmüş Studentlərin ad və soyadını list şəklində qaytaran funksiya yazın.


create function task4(@start datetime,@end datetime)
returns table
return
select Students.FirstName,Students.LastName from Students
inner join S_Cards on Students.Id=S_Cards.Id_Student
where S_Cards.DateOut >= @start and S_Cards.DateOut <= @end


select * from task4('01-01-2001','01-01-2010')

--5. Write a function that returns a list of students who are currently working with the specified book of a certain author.
--5. Müəyyən kitabla hal hazırda işləyən bütün tələbələrin siyahısını qaytaran funksiya yazın.

create function task5()
returns table
return
select Students.FirstName,Students.LastName from Students
inner join S_Cards on Students.Id=S_Cards.Id_Student
where S_Cards.DateIn is null

select * from task5()


--6. Write a function that returns information about publishers whose total number of pages of books issued by them is greater than N.
--6. Çap etdiyi bütün səhifə cəmi N-dən böyük olan Publisherlər haqqında informasiya qaytaran funksiya yazın.

create FUNCTION countpage
(
    @count bigint
)
RETURNS Table
Return
	SELECT sum(Books.Pages) as 'Sum',Press.[Name] FROM Books
    inner join Press on Press.Id=Books.Id_Press
    group by Press.[Name]
    Having sum(Books.Pages) > @count

select * from countpage(1119)


--7. Write a function that returns information about the most popular author among students and about the number of books of this author taken in the library.
--7.Studentlər arasında Ən popular avtor və onun götürülmüş kitablarının sayı haqqında informasiya verən funksiya yazın 

create function authors_c()
returns table
return
     select Authors.FirstName,Authors.LastName, count(Books.Id) as Say from Books
     inner join S_Cards on S_Cards.Id_Book=Books.Id
	 inner join Authors on Books.Id_Author=Authors.Id
	 group by Authors.FirstName,Authors.LastName

select * from authors_c()

--8. Write a function that returns a list of books that were taken by both teachers and students.
--Studentlər və Teacherlər (hər ikisi) tərəfindən götürülmüş (ortaq - həm onlar həm bunlar) kitabların listini qaytaran funksiya yazın.

create function books_()
returns table
return
     select Books.[Name] from Books
     inner join S_Cards on S_Cards.Id_Book=Books.Id
     Intersect 
     select Books.[Name] from Books
     inner join T_Cards on T_Cards.Id_Book=Books.Id

select * from books_()

--9. Write a function that returns the number of students who did not take books.
--9. Kitab götürməyən tələbələrin sayını qaytaran funksiya yazın.

create function stcount()
returns int
as
begin
    declare @count int
	declare @count2 int

	select  @count = Count(*)   from Students
	inner join S_Cards on S_Cards.Id_Student=Students.Id

	select  @count2 = Count(*)   from Students

	return @count2-@count

end

print dbo.stcount()

--10. Write a function that returns a list of librarians and the number of books issued by each of them.
--10. Kitabxanaçılar və onların verdiyi kitabların sayını qaytaran funksiya yazın.
create function lib_count()
returns table
return	
	SELECT  Libs.[FirstName],count(Books.Id) as 'Book Count'
	FROM Libs
	INNER JOIN S_Cards ON S_Cards.Id_Lib = Libs.Id
	INNER JOIN Books ON S_Cards.Id_Book = Books.Id
	GROUP BY Libs.[FirstName]

select *from lib_count()