create table request_counts
(
  id int auto_increment,
  prefix varchar(255) not null,
  counters json not null,
  counted_at datetime null,
  primary key (id)
);
