Założenia:
Separacja danych na poziomie bazy danych dla jednego klienta.
Tabela z użytkownikami o kolumnach (user_id, user_name, user_surname, user_role, user_group_id, user_active, aud_data, aud_login)
Tabela z grupami użytkowników, zespołów o kolumnach (group_id, group_opis, aud_data, aud_login)
Tabela z zadaniem o kolumnach (task_id, task_priority, task_user_id, task_date_add, task_date_finish, task_active, task_status_id, aud_data, aud_login)
Tabela z statusami zadania - zmiany o kolumnach (status_id, status_opis, status_user_id) 
Tabela z statusami zadań (status_id, status_opis, aud_data, aud_login)

