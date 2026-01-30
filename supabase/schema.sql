CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (
    id,
    email,
    nome,
    cognome,
    ruolo,
    legge_104,
    importo_trasferte,
    sede,
    orari_settimanali
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nome', ''),
    COALESCE(NEW.raw_user_meta_data->>'cognome', ''),
    COALESCE(NEW.raw_user_meta_data->>'ruolo', 'dipendente'),
    COALESCE((NEW.raw_user_meta_data->>'legge_104')::boolean, false),
    COALESCE((NEW.raw_user_meta_data->>'importo_trasferte')::numeric, 0),
    COALESCE((NEW.raw_user_meta_data->>'sede')::sede_type, 'Viareggio'),
    NEW.raw_user_meta_data->'orari_settimanali'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
