create table users(
    id number primary key,
    name varchar(200) not null,
    email varchar(200) not null
);
create table phones(
    id number primary key,
    number varchar(100) not null,
    owner number not null,
    foreign key (owner) references users(id)
);