-- APIs --
create or replace package tn1_table_api
is
 
    /* example:
        declare
            l_field                         varchar2(4000);
        begin
        tn1_table_api.get_row (
            p_id                            => 1,
            p_field                         => l_field
            );
        end;
    */

    procedure get_row (
        p_id                           in  number,
        p_field                        out varchar2
    );
 
    /* example:
        begin
        tn1_table_api.insert_row (
            p_id                          => null,
            p_field                       => null
            );
        end;
    */

    procedure insert_row  (
        p_id                           in number default null,
        p_field                        in varchar2 default null
    );
    procedure update_row  (
        p_id                           in number default null,
        p_field                        in varchar2 default null
    );
    procedure delete_row (
        p_id                           in number
    );
end tn1_table_api;
/


create or replace package  body tn1_table_api
is
 
    procedure get_row (
        p_id                           in  number,
        p_field                        out varchar2
    )
    is
    begin
        for c1 in (select * from tn1_table where id = p_id 
                                             and tenant_id = coalesce(to_number(tn1_tenant_pkg.get_tenant_id),0)
                  ) loop
            p_field := c1.field;
        end loop;
    end get_row;

 
    procedure insert_row  (
        p_id                           in number default null,
        p_field                        in varchar2 default null
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
        p_field                        in varchar2 default null
    )
    is
    begin
        update  tn1_table set 
            id = p_id,
            field = p_field
        where id = p_id
          and tenant_id = coalesce(to_number(tn1_tenant_pkg.get_tenant_id),0)
          ;
    end update_row;

    procedure delete_row (
        p_id                           in number
    )
    is
    begin
        delete from tn1_table where id = p_id
                                and tenant_id = coalesce(to_number(tn1_tenant_pkg.get_tenant_id),0)
                                ;
    end delete_row;
end tn1_table_api;
/