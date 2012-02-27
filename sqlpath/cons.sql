declare

-- Show information about a constraint.
--
-- Parameter: name of constraint
--
-- Currently: only PK and FK constraints supported.

   r_constraint    all_constraints%rowtype;
   r_constraint_pk all_constraints%rowtype;
 
begin

   dbms_output.new_line;
 
   select * into r_constraint from all_constraints where constraint_name = '&1';
 
   if    r_constraint.constraint_type = 'R' then -- {
 
         select * into r_constraint_pk from all_constraints where constraint_name = r_constraint.r_constraint_name;
 
         dbms_output.put_line('  Foreign Key constraint');
         dbms_output.new_line;
         dbms_output.put_line('    ' || rpad(r_constraint.table_name, 30) || ' -> ' || r_constraint_pk.table_name);
         dbms_output.put_line('    ' || rpad('-', 30, '-')                || '    ' || rpad('-', 30, '-'));
 
         for cols in (
 
             select 
               fk_col.column_name  column_name_fk,
               pk_col.column_name  column_name_pk
             from
               all_cons_columns   fk_col,
               all_cons_columns   pk_col
             where
               fk_col.constraint_name = r_constraint   .constraint_name and
               pk_col.constraint_name = r_constraint_pk.constraint_name and
               fk_col.position        = pk_col.position
             order by
               fk_col.position
                
         ) loop
 
           dbms_output.put_line('    ' || rpad(cols.column_name_fk, 30) || '    ' || cols.column_name_pk);
 
         end loop;
   -- }
   elsif r_constraint.constraint_type = 'P' then -- {

         dbms_output.put_line('  Primary Key constraint');
         dbms_output.new_line;
         dbms_output.put_line('     Table: ' || r_constraint.table_name);
         dbms_output.new_line;

         for cols in (

             select column_name
               from all_cons_columns
              where constraint_name = r_constraint.constraint_name
              order by position

         ) loop
              
           dbms_output.put_line('            ' || cols.column_name);

         end loop;
 
   end if; -- }

end;
/
