create table users(
	userid int not null,
	name text not null,
	primary key(userid)
);
create table movies(
	movieid int not null,
	title text not null,
	primary key(movieid)
);
create table taginfo(
	tagid int not null,
	content text not null,
	primary key(tagid)
);
create table genres(
	genreid int not null,
	name text not null,
	primary key(genreid)
);
create table ratings(
	userid int not null,
	movieid int not null,
	rating numeric check(rating >=0 and rating <=5) not null,
	timestamp bigint not null,
	primary key(userid, movieid),
	foreign key(userid) references users on delete cascade,
	foreign key(movieid) references movies on delete cascade
);
create table tags(
	userid int not null,
	movieid int not null,
	tagid int not null,
	timestamp bigint not null,
	primary key(userid, movieid, tagid),
	foreign key(userid) references users on delete cascade,
	foreign key(movieid) references movies on delete cascade,
	foreign key(tagid) references taginfo on delete cascade
);
create table hasagenre(
	movieid int not null,
	genreid int not null,
	primary key(movieid, genreid),
	foreign key(movieid) references movies on delete cascade,
	foreign key(genreid) references genres on delete cascade
);
