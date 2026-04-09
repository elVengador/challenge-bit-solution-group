-- 1. Create Tables
-- Note: 'auth.users' is a built-in schema, so we reference it directly.

create table if not exists products (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  description text not null,
  image text not null,
  category text not null,
  price numeric not null,
  stock int8 not null default 0,
  status boolean not null default true,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

create table if not exists profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique
);

-- 2. Setup Logic (Functions and Triggers)
-- This function automatically creates a profile row when a new user signs up.

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.raw_user_meta_data->>'username');
  return new;
end;
$$ language plpgsql security definer;

-- Remove existing trigger if it exists to avoid errors on re-run
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 3. Enable Security
alter table products enable row level security;
alter table profiles enable row level security;

-- 4. Create Policies
create policy "only authenticated users" 
on products for all 
to authenticated 
using (true) 
with check (true);

CREATE POLICY "allow public read product" 
ON public.products 
FOR SELECT 
USING (true);

-- 5. Seed Data
insert into products (name, description, image, category, price, stock, status) values
('iPhone 15 Pro', 'Titanium Black, 256GB. The ultimate iPhone cam.', 'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=400', 'Electronics', 999.00, 25, true),
('Sony WH-1000XM5', 'Wireless Noise Cancelling Headphones, Black.', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=400', 'Electronics', 348.50, 15, true),
('Cotton White Tee', 'Essential slim-fit organic cotton t-shirt.', '', 'Clothing', 25.00, 100, true),
('Nike Air Max', 'Iconic sneakers with maximum cushioning.', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', 'Clothing', 120.99, 40, true),
('Minimalist Desk Lamp', 'Adjustable LED lamp with 3 color modes.', 'https://images.unsplash.com/photo-1534073828943-f801091bb18c?w=400', 'Home', 45.00, 10, true),
('Ceramic Plate Set', 'Set of 4 matte black dinner plates.', '', 'Home', 32.40, 60, true),
('Yoga Mat Pro', '6mm non-slip eco-friendly rubber mat.', '', 'Sports', 55.00, 0, false),
('Iron Dumbbells 10kg', 'Pair of solid cast iron weights.', 'https://images.unsplash.com/photo-1586401100295-7a8096fd231a?w=400', 'Sports', 89.00, 5, true),
('Leather Notebook', 'Handcrafted A5 journal with premium paper.', 'https://images.unsplash.com/photo-1517842645767-c639042777db?w=400', 'Other', 18.25, 30, true),
('Bamboo Fountain Pen', 'Eco-friendly pen with refillable ink.', '', 'Other', 12.00, 120, true);