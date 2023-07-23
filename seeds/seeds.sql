DROP TABLE IF EXISTS "users", "posts", "comments" CASCADE;
CREATE TABLE "users" (
    "id" SERIAL PRIMARY KEY,
    "name" text,
    "username" text,
    "email_address" text,
    "password" text
);

CREATE TABLE "posts" (
    "id" SERIAL PRIMARY KEY,
    "title" text,
    "content" text,
    "date" DATE,
    "user_id" int4,
    constraint fk_user foreign key (user_id)
    references users(id) ON DELETE CASCADE
);

CREATE TABLE "comments" (
    "id" SERIAL PRIMARY KEY,
    "content" text,
    "date" DATE,
    "user_id" int4,
    "post_id" int4,
    constraint fk_user foreign key (user_id)
    references users(id) ON DELETE CASCADE,
    constraint fk_post foreign key (post_id)
    references posts(id) ON DELETE CASCADE
);

INSERT INTO "public"."users" ("name", "username", "email_address", "password") VALUES
('George Orwell', 'gomakers', 'gomakers@makers.com', '1984'),
('Sam Morgan', 'sjmog', 'samm@makers.com', 'magma'),
('Husnain Rashid', 'hrashid', 'hrashid@makers.com', 'password123');

INSERT INTO "public"."posts" ("title", "content", "date", "user_id") VALUES
('hello', 'goodbye after', '2008-11-11', 1),
('goodbye', 'hello after', '2010-12-09', 1),
('evening', 'late hello', '2012-08-06', 2),
('nobody', 'everyone is here', '2015-01-04', 3);

INSERT INTO "public"."comments" ("content", "date", "user_id", "post_id") VALUES
('This was a very accurate comment', '2008-11-12', 2, 1),
('This was completely innaccurate', '2010-12-11',  3, 2),
('Sherlock is a good tv show', '2012-08-09', 1, 3);



