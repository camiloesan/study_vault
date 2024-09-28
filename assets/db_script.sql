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
    description varchar(64),
    -- todo add category on a catalog
    primary key(channel_id),
    unique(channel_id)
);

create table posts(
    post_id int not null auto_increment,
    channel_id int not null,
    file_id int not null,
    title varchar(32) not null,
    description varchar(128),
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