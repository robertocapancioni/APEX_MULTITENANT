-- APIs --
create or replace package tn1_tenant_pkg
is
    function get_tenant_id 
      return varchar2;
end tn1_tenant_pkg;
/


create or replace package  body tn1_tenant_pkg 
is 
    function get_tenant_id  
      return varchar2 
    is
      l_tenant_id varchar2(100) := '0';  
    begin 
      if SYS_CONTEXT('APEX$SESSION', 'APP_TENANT_ID') is not null 
      then 
        l_tenant_id := SYS_CONTEXT('APEX$SESSION', 'APP_TENANT_ID'); 
      else 
         select nvl(any_value(tenant_id),l_tenant_id) into l_tenant_id  
         from tn1_user  
         where username = coalesce(sys_context('APEX$SESSION','APP_USER'),sys_context('APEX$SESSION','CURRENT_USER'),user); 
        apex_session.set_tenant_id (p_tenant_id => l_tenant_id);         
      end if; 
      return l_tenant_id; 
    end get_tenant_id; 
end tn1_tenant_pkg; 
/

/*
procedure post_autentication
is
begin
  :AI_TENANT_ID := tn1_tenant_pkg.get_tenant_id;
end;
*/