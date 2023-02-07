create database if not exists 48hoursYnov;
use 48hoursYnov;
create table if not exists Roles(
  id int auto_increment not null,
  libelle varchar(255) not null,
  primary key(id)
);

create table if not exists Utilisateurs(
  id int auto_increment not null,
  email varchar(255) not null unique,
  password text not null,
  idRole int not null,
  primary key(id),
  foreign key (idRole) references Roles(id)
);

create table if not exists Marchand(
  id int auto_increment not null,
  nom varchar(255),
  primary key(id)
);

create table if not exists Produit(
  id int auto_increment not null,
  nom varchar(255) not null,
  description varchar(255) not null,
  prix float not null,
  idMarchand int not null,
  primary key(id),
  foreign key (idMarchand) references Marchand(id)
);

create table if not exists Commande(
  id int auto_increment not null,
  idUtilisateur int not null,
  idInstance int not null,
  primary key (id)
);

create table if not exists produitCommander(
  idCommande int not null,
  idProduit int not null,
  qte int not null,
  primary key (idCommande, idProduit),
  foreign key (idCommande) references Commande(id),
  foreign key (idProduit) references Produit(id)
);