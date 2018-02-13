SELECT xt.create_table('taxauth', 'public');

ALTER TABLE public.taxauth DISABLE TRIGGER ALL;

SELECT
  xt.add_column('taxauth', 'taxauth_id',        'SERIAL', 'NOT NULL', 'public'),
  xt.add_column('taxauth', 'taxauth_crmacct_id',  'INTEGER', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_code',        'TEXT', 'NOT NULL', 'public'),
  xt.add_column('taxauth', 'taxauth_name',        'TEXT', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_extref',      'TEXT', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_addr_id',  'INTEGER', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_curr_id',  'INTEGER', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_county',      'TEXT', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_accnt_id', 'INTEGER', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_created',     'TIMESTAMP WITH TIME ZONE', NULL, 'public'),
  xt.add_column('taxauth', 'taxauth_lastupdated', 'TIMESTAMP WITH TIME ZONE', NULL, 'public');

SELECT
  xt.add_constraint('taxauth', 'taxauth_pkey', 'taxauth_id', 'public'),
  xt.add_constraint('taxauth', 'taxauth_taxauth_code_check',
                    $$CHECK (taxauth_code <> '')$$, 'public'),
  xt.add_constraint('taxauth', 'taxauth_taxauth_code_key',
                    'UNIQUE (taxauth_code)', 'public'),
  xt.add_constraint('taxauth', 'taxauth_crmacct_id_fkey',
                    'FOREIGN KEY (taxauth_crmacct_id) REFERENCES crmacct(crmacct_id)
                     MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public'),
  xt.add_constraint('taxauth', 'taxauth_crmacct_id_key', 'UNIQUE (taxauth_crmacct_id)', 'public'),
  xt.add_constraint('taxauth', 'taxauth_taxauth_accnt_id_fkey',
                    'FOREIGN KEY (taxauth_accnt_id) REFERENCES accnt(accnt_id)', 'public'),
  xt.add_constraint('taxauth', 'taxauth_taxauth_addr_id_fkey',
                    'FOREIGN KEY (taxauth_addr_id) REFERENCES addr(addr_id)', 'public'),
  xt.add_constraint('taxauth', 'taxauth_taxauth_curr_id_fkey',
                    'FOREIGN KEY (taxauth_curr_id) REFERENCES curr_symbol(curr_id)', 'public');

-- Version 5.0 data migration
DO $$
BEGIN

  IF EXISTS(SELECT column_name FROM information_schema.columns 
            WHERE table_name='crmacct' and column_name='crmacct_taxauth_id') THEN

     UPDATE taxauth SET taxauth_crmacct_id=(SELECT crmacct_id FROM crmacct WHERE crmacct_taxauth_id=taxauth_id);
  END IF;
END$$;

ALTER TABLE taxauth ALTER COLUMN taxauth_crmacct_id SET NOT NULL;

ALTER TABLE public.taxauth ENABLE TRIGGER ALL;

COMMENT ON TABLE taxauth IS 'The Tax Authority table.';
COMMENT ON COLUMN taxauth.taxauth_curr_id IS 'The required currency for recording tax information as. NULL means no preference.';
