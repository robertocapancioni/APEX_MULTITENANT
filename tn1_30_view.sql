create or replace view tn1_table_vw as
select id,
       --tenant_id,
       field,
       created,
       created_by,
       updated,
       updated_by
  from tn1_table t
 where tenant_id = coalesce(to_number(SYS_CONTEXT('APEX$SESSION', 'APP_TENANT_ID')),0);

create or replace trigger tn1_table_vw_itrg 
instead of insert on tn1_table_vw 
for each row 
begin 
        tn1_table_api.insert_row  (
                p_id                           => :new.id,
                p_field                        => :new.field
            );
end; 
/

create or replace trigger tn1_table_vw_utrg 
instead of update on tn1_table_vw 
for each row 
begin 
        tn1_table_api.update_row  (
                p_id                           => :new.id,
                p_field                        => :new.field
        );
end; 
/

create or replace trigger tn1_table_vw_dtrg 
instead of delete on tn1_table_vw 
for each row 
begin 
        tn1_table_api.delete_row (
                p_id                           => :old.id
    );
end; 
/




