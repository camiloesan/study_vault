drop database if exists study_vault;
create database study_vault default character set utf8mb4;
use study_vault;

create table users(
    user_id int not null auto_increment,
    user_type_id int not null,
    name varchar(32) not null,
    last_name varchar(64) not null,
    email varchar(64) not null,
    password varchar(64) not null,
    primary key(user_id),
    unique(user_id),
    unique(email)
);

create table user_types(
    user_type_id int not null auto_increment,
    user_type varchar(10) not null,
    primary key(user_type_id),
    unique(user_type_id)
);

create table subscriptions(
    subscription_id int not null auto_increment,
    user_id int not null,
    channel_id int not null,
    primary key(subscription_id),
    unique(subscription_id) 
);

create table channels(
    channel_id int not null auto_increment,
    creator_id int not null,
    name varchar(32) not null,
    description varchar(256),
    -- todo add category on a catalog
    primary key(channel_id),
    unique(channel_id)
);

create table posts(
    post_id int not null auto_increment,
    channel_id int not null,
    file_id int not null,
    title varchar(32) not null,
    description varchar(256),
    publish_date date not null,
    primary key(post_id),
    unique(post_id)
);

create table comments(
    comment_id int not null auto_increment,
    post_id int not null,
    user_id int not null,
    comment varchar(256) not null,
    publish_date date not null,
    primary key(comment_id),
    unique(comment_id)
);

create table files(
    file_id int not null auto_increment,
    name varchar(8) not null,
    uri varchar(128) not null,
    primary key(file_id),
    unique(file_id),
    unique(uri)
);

-- foreign keys

alter table users
add constraint fk_users_user_types foreign key(user_type_id) references user_types(user_type_id) on delete cascade on update cascade;

alter table subscriptions
add constraint fk_subscriptions_users foreign key(user_id) references users(user_id) on delete cascade on update cascade,
add constraint fk_subscriptions_channels foreign key(channel_id) references channels(channel_id) on delete cascade on update cascade;

alter table channels
add constraint fk_channels_users foreign key(creator_id) references users(user_id) on delete cascade on update cascade;

alter table posts
add constraint fk_posts_channels foreign key(channel_id) references channels(channel_id) on delete cascade on update cascade,
add constraint fk_posts_files foreign key(file_id) references files(file_id) on delete cascade on update cascade;

alter table comments
add constraint fk_comments_post foreign key(post_id) references posts(post_id) on delete cascade on update cascade,
add constraint fk_comments_users foreign key(user_id) references users(user_id) on delete cascade on update cascade;

-- startup data

insert into user_types(user_type) values('Professor');
insert into user_types(user_type) values('Student');

insert into users(user_type_id, name, last_name, email, password) values(2, 'Camilo', 'Espejo Sánchez', 'zs21013861@estudiantes.uv.mx', '123456');
insert into users(user_type_id, name, last_name, email, password) values(1, 'Lizbeth', 'Rodríguez Mesa', 'lizrm@uv.mx', '123456');

insert into channels(creator_id, name, description) values(2, 'Filosofía básica 1', 'Filosofía Básica 1 introduce los conceptos fundamentales de la filosofía, abordando temas como la naturaleza del conocimiento, la realidad, la ética y la lógica.');
insert into channels(creator_id, name, description) values(2, 'Literatura 4', 'Literatura Básica 1 ofrece una introducción a los principales géneros literarios, como la poesía, la narrativa y el teatro. A través del análisis de obras de diferentes épocas y culturas');
insert into channels(creator_id, name, description) values(2, 'Matemáticas 101', 'Este curso de Matemáticas 101 cubre los conceptos fundamentales de álgebra, geometría y cálculo, proporcionando las bases necesarias para estudios avanzados.');
insert into channels(creator_id, name, description) values(2, 'Historia del Arte', 'Historia del Arte explora las principales corrientes artísticas y sus contextos históricos, analizando obras de diferentes períodos y estilos.');
insert into channels(creator_id, name, description) values(2, 'Ciencias Naturales', 'El curso de Ciencias Naturales aborda los principios básicos de la biología, química y física, fomentando una comprensión integral del mundo natural.');

insert into subscriptions(user_id, channel_id) values(1, 1);
insert into subscriptions(user_id, channel_id) values(1, 2);