-- APIs --
create or replace package tn1_table_api_rest
is
 
    procedure get_row (
        p_id                           in  number,
        p_field                        out varchar2,
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    );
 
    procedure insert_row  (
        p_id                           in number default null,
        p_field                        in varchar2 default null,
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    );
    procedure update_row  (
        p_id                           in number default null,
        p_field                        in varchar2 default null,
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    );
    procedure delete_row (
        p_id                           in number,
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    );
    function get_rows(
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    ) return clob sql_macro;
end tn1_table_api_rest;
/

create or replace package  body tn1_table_api_rest
is
 
    procedure get_row (
        p_id                           in  number,
        p_field                        out varchar2,
        p_app_user                     in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    )
    is
    begin
        for c1 in (select * from tn1_table where id = p_id 
                                             and tenant_id = (select nvl(any_value(u.tenant_id),0) from tn1_user u where username = p_app_user)
                  ) loop
            p_field := c1.field;
        end loop;
    end get_row;

 
    procedure insert_row  (
        p_id                           in number default null,
        p_field                        in varchar2 default null,
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    )
    is
    begin
        insert into tn1_table (
            id,
            field
        ) values (
            p_id,
            p_field
        );
    end insert_row;

    procedure update_row  (
        p_id                           in number default null,
        p_field                        in varchar2 default null,
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    )
    is
    begin
        update  tn1_table set 
            id = p_id,
            field = p_field
        where id = p_id
          and tenant_id = (select nvl(any_value(u.tenant_id),0) from tn1_user u where username = p_app_user)
          ;
    end update_row;

    procedure delete_row (
        p_id                           in number,
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    )
    is
    begin
        delete from tn1_table where id = p_id
                                and tenant_id = (select nvl(any_value(u.tenant_id),0) from tn1_user u where username = p_app_user)
                                ;
    end delete_row;
    function get_rows(
        p_app_user                in varchar default  coalesce(sys_context('APEX$SESSION','APP_USER'),user)
    ) return clob sql_macro
    is
    begin
      return q'{
            select t.id,
                   t.tenant_id,
                   t.field,
                   t.created,
                   t.created_by,
                   t.updated,
                   t.updated_by
              from tn1_table t
              join tn1_user u on t.tenant_id = u.tenant_id 
                             and u.username = p_app_user
      }';
    end get_rows;
end tn1_table_api_rest;
/