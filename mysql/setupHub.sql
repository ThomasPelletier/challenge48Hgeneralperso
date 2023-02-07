create database if not exists hub;
use hub;
create table if not exists Instance(
  id int auto_increment not null,
  ip varchar(20) not null,
  domaine varchar(255) not null,
  primary key(id)
);