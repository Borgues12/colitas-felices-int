
  select * from registro_temporal;


  delete from perfil;
  delete from cuenta;

  delete from registro_temporal;
  DBCC CHECKIDENT ('cuenta', RESEED,0)
  DBCC CHECKIDENT ('perfil', RESEED, 0)
  DBCC CHECKIDENT ('registro_temporal', RESEED, 0)
