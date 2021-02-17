# 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select *
from client
where length(FirstName) < 6;


# -------------------------------------------------------------------------------------------------------------------
# 2. +Вибрати львівські відділення банку.+
select *
from department
where DepartmentCity like 'Lviv';


# -------------------------------------------------------------------------------------------------------------------
# 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select *
from client
where Education like 'high'
order by LastName;


# -------------------------------------------------------------------------------------------------------------------
# 4. +Виконати сортування у зворотньому порядку над таблицею і вивести 5 останніх елементів.
select *
from client
order by idClient desc
limit 5;



# -------------------------------------------------------------------------------------------------------------------
# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на IV чи IVA.
select *
from client
where LastName like '%iv'
   or LastName like '%iva';


# -------------------------------------------------------------------------------------------------------------------
# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select FirstName, DepartmentCity
from client
         join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'kyiv';

# -------------------------------------------------------------------------------------------------------------------
# 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
select FirstName, Passport
from client
order by FirstName;


# -------------------------------------------------------------------------------------------------------------------
# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select FirstName, Passport, a.Sum as TotalCredit
from client
         join application a on client.idClient = a.Client_idClient
where Sum > 5000
order by TotalCredit desc;


# -------------------------------------------------------------------------------------------------------------------
# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(Department_idDepartment) as TotalClients
from client
         join application a on client.idClient = a.Client_idClient
         join department d on d.idDepartment = client.Department_idDepartment;

select count(Department_idDepartment) as TotalClients
from client
         join application a on client.idClient = a.Client_idClient
         join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'Lviv';


# -------------------------------------------------------------------------------------------------------------------
# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select FirstName, max(Sum) as MaxCreditSum
from client
         join application a on client.idClient = a.Client_idClient
group by FirstName
order by MaxCreditSum desc;

# -------------------------------------------------------------------------------------------------------------------
# 11. Визначити кількість заявок на кредит для кожного клієнта.
select FirstName, count(Client_idClient) as TotalCreditRequests
from client
         join application a on client.idClient = a.Client_idClient
group by FirstName
order by TotalCreditRequests desc;

# -------------------------------------------------------------------------------------------------------------------
# 12. Визначити найбільший та найменший кредити.
select max(Sum) as MaxCredit, min(Sum) as MinCredit
from application;



# -------------------------------------------------------------------------------------------------------------------
# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select count(client.Education) as TotalCredits
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high';

# -------------------------------------------------------------------------------------------------------------------
# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select FirstName, avg(a.Sum) as AvgCreditSum
from client
         join department d on d.idDepartment = client.Department_idDepartment
         join application a on client.idClient = a.Client_idClient
group by FirstName
order by AvgCreditSum desc
limit 1;


# -------------------------------------------------------------------------------------------------------------------
# 15. Вивести відділення, яке видало в кредити найбільше грошей
select DepartmentCity, sum(a.Sum) as TotalCreditSum
from client
         join application a on client.idClient = a.Client_idClient
         join department d on d.idDepartment = client.Department_idDepartment
group by DepartmentCity
limit 1;

# 16. Вивести відділення, яке видало найбільший кредит.
select DepartmentCity, max(a.Sum) as MaxCreditSum
from client
         join department d on d.idDepartment = client.Department_idDepartment
         join application a on client.idClient = a.Client_idClient
group by DepartmentCity
limit 1;

# -------------------------------------------------------------------------------------------------------------------
# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update client join application a on client.idClient = a.Client_idClient
set a.Sum   =6000,
    Currency='Gryvnia'
where Education = 'high';

select FirstName, Education, Sum
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high'
order by FirstName;

# -------------------------------------------------------------------------------------------------------------------
# 18. Усіх клієнтів київських відділень пересилити до Києва.

update client join department d on d.idDepartment = client.Department_idDepartment
set City='Kyiv'
where DepartmentCity = 'Kyiv';



# -------------------------------------------------------------------------------------------------------------------
# 19. Видалити усі кредити, які є повернені.
delete application
from application
where CreditState = 'Returned';


# -------------------------------------------------------------------------------------------------------------------
# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.

delete application
from application
         join client c on c.idClient = application.Client_idClient
         join department d on d.idDepartment = c.Department_idDepartment
where c.LastName regexp '^.[aoeiuy]';

# -------------------------------------------------------------------------------------------------------------------
# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select DepartmentCity, Sum
from client
         join department d on d.idDepartment = client.Department_idDepartment
         join application a on client.idClient = a.Client_idClient
where DepartmentCity = 'Lviv'
  and Sum > 5000
order by Sum;

# -------------------------------------------------------------------------------------------------------------------
# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select FirstName, Sum, CreditState
from client
         join application a on client.idClient = a.Client_idClient
where CreditState = 'Returned'
  and Sum > 5000
order by Sum desc;


# -------------------------------------------------------------------------------------------------------------------
/* Знайти максимальний неповернений кредит.*/
select FirstName, Sum, CreditState
from client
         join application a on client.idClient = a.Client_idClient
where CreditState = 'Not returned'
order by Sum desc
limit 1;


# -------------------------------------------------------------------------------------------------------------------
/*Знайти клієнта, сума кредиту якого найменша*/
select FirstName, Sum
from client
         join application a on client.idClient = a.Client_idClient
order by Sum
limit 1;
