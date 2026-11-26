-- 1) TABELAS
create table if not exists public.packages(id text primary key, status text not null default 'rascunho' check (status in ('rascunho','publicado')), data jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.site_config(id text primary key, data jsonb not null default '{}'::jsonb);
create table if not exists public.admins(user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.packages enable row level security;
alter table public.site_config enable row level security;
alter table public.admins enable row level security;
-- 2) QUEM É ADMINISTRADOR
create or replace function public.is_admin() returns boolean language sql security definer set search_path=public stable as $$ select exists(select 1 from public.admins where user_id=auth.uid()) $$;
-- 3) PERMISSÕES
revoke all on public.packages, public.site_config, public.admins from anon, authenticated;
grant select on public.packages, public.site_config to anon, authenticated;
grant insert, update, delete on public.packages, public.site_config to authenticated;
grant select on public.admins to authenticated;
grant execute on function public.is_admin() to anon, authenticated;
drop policy if exists pk_read on public.packages; drop policy if exists pk_write on public.packages;
drop policy if exists cf_read on public.site_config; drop policy if exists cf_write on public.site_config; drop policy if exists ad_read on public.admins;
create policy pk_read on public.packages for select using (status='publicado' or public.is_admin());
create policy pk_write on public.packages for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy cf_read on public.site_config for select using (true);
create policy cf_write on public.site_config for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy ad_read on public.admins for select to authenticated using (user_id=auth.uid());
-- 4) PACOTES ATUAIS DO SITE
insert into public.packages(id,status,data) values ('egito-imperial','publicado',$j${"id": "egito-imperial", "nome": "Egito Imperial — uma viagem pela história dos faraós", "curto": "Egito Imperial", "pais": "Egito", "tags": ["África", "Experiências exclusivas"], "dur": "8 dias e 7 noites", "saida": "15 de setembro de 2027", "preco": 12990, "parc": "Em até 10x de R$ 1.299", "demo": true, "destaque": true, "status": "publicado", "sub": "Descubra os mistérios de uma das civilizações mais fascinantes da humanidade.", "desc": "Cairo e Luxor, com hotéis categoria superior e café da manhã.", "a": "#e8a85a", "b": "#4a2818", "inc": ["Hospedagem durante o roteiro", "Café da manhã", "Traslados previstos no roteiro", "Passeios guiados conforme programação", "Visita às Pirâmides de Gizé", "Visita à Esfinge", "Experiência cultural no Cairo", "Visitas a templos históricos em Luxor", "Acompanhamento conforme condições do pacote"], "nao": ["Passagens aéreas, seguro e taxas: consulte a equipe, pois só constam como inclusos se confirmados"], "rot": [["Dia 01 — Chegada ao Cairo", "Recepção e traslado para hospedagem."], ["Dia 02 — As Pirâmides de Gizé", "Conheça as grandiosas pirâmides e a Esfinge."], ["Dia 03 — Cairo cultural", "Explore a história, a arquitetura e os tesouros culturais da cidade."], ["Dia 04 — Experiência no Egito", "Dia dedicado a experiências culturais e descobertas locais."], ["Dia 05 — Cairo a Luxor", "Deslocamento conforme programação do pacote."], ["Dia 06 — Templos de Luxor", "Descubra monumentos históricos e a herança dos faraós."], ["Dia 07 — Luxor e arredores", "Continue explorando a riqueza histórica da região."], ["Dia 08 — Retorno", "Traslado conforme programação e encerramento da viagem."]], "gal": ["Pirâmides de Gizé", "Grande Esfinge", "Templos de Luxor", "Rio Nilo", "Paisagens do deserto", "Arquitetura egípcia"]}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('maldivas','publicado',$j${"id": "maldivas", "nome": "Maldivas", "pais": "Maldivas", "tags": ["Ásia", "Experiências exclusivas"], "sub": "Paraíso em águas cristalinas.", "desc": "Paraíso em águas cristalinas.", "a": "#7fd0d0", "b": "#0b5d6b", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('italia','publicado',$j${"id": "italia", "nome": "Itália", "pais": "Itália", "tags": ["Europa"], "sub": "Uma jornada pela arte e gastronomia.", "desc": "Uma jornada pela arte e gastronomia.", "a": "#e6c98c", "b": "#7a4a2a", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('japao','publicado',$j${"id": "japao", "nome": "Japão", "pais": "Japão", "tags": ["Ásia"], "sub": "Entre tradição e modernidade.", "desc": "Entre tradição e modernidade.", "a": "#e8b6bd", "b": "#5a2b3c", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('suica','publicado',$j${"id": "suica", "nome": "Suíça", "pais": "Suíça", "tags": ["Europa"], "sub": "Uma experiência pelos Alpes.", "desc": "Uma experiência pelos Alpes.", "a": "#b9d3e6", "b": "#26405a", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('alasca','publicado',$j${"id": "alasca", "nome": "Alasca", "pais": "Alasca, EUA", "tags": ["América", "Experiências exclusivas"], "sub": "Natureza em sua forma mais extraordinária.", "desc": "Natureza em sua forma mais extraordinária.", "a": "#9cc4c0", "b": "#1c3438", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('antartica','publicado',$j${"id": "antartica", "nome": "Antártica", "pais": "Antártica", "tags": ["Experiências exclusivas", "Cruzeiros"], "sub": "Uma expedição ao fim do mundo.", "desc": "Uma expedição ao fim do mundo.", "a": "#dfeaf2", "b": "#34566e", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('amazonia','publicado',$j${"id": "amazonia", "nome": "Amazônia", "pais": "Brasil", "tags": ["América", "Experiências exclusivas"], "sub": "Uma experiência imersiva na natureza.", "desc": "Uma experiência imersiva na natureza.", "a": "#8fb06a", "b": "#1f3a22", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.packages(id,status,data) values ('cruzeiros','publicado',$j${"id": "cruzeiros", "nome": "Cruzeiros", "pais": "Vários destinos", "tags": ["Cruzeiros"], "sub": "Descubra o mundo navegando.", "desc": "Descubra o mundo navegando.", "a": "#1c3a5a", "b": "#0b1a2b", "status": "publicado"}$j$::jsonb) on conflict (id) do nothing;
insert into public.site_config(id,data) values ('site','{"wa":"5513997521975"}'::jsonb) on conflict (id) do nothing;

-- 5) DEPOIS DE CRIAR O USUÁRIO EM Authentication > Users, rode (troque o e-mail):
-- insert into public.admins(user_id) select id from auth.users where email='SEU_EMAIL_AQUI';
