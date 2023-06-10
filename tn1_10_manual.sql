-- triggers
create or replace trigger tn1_table_biu
    before insert or update 
    on tn1_table
    for each row
begin
    if :new.tenant_id is null then
       :new.tenant_id := coalesce(to_number(tn1_tenant_pkg.get_tenant_id),0);
    end if;
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end tn1_table_biu;
/


/*
EXEC apex_session.attach(p_app_id => 101, p_page_id => 1, p_session_id => 115310927172254);

EXEC apex_session.set_tenant_id (p_tenant_id => 2);


*/