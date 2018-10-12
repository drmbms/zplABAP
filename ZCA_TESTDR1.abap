* ------------------------------------------------------------------- *
* Report ZCA_TESTDR1
* ------------------------------------------------------------------- *
*
* Program Name      : ZCA_TESTDR1
* Description       : Testprint to Zebra printer
* Author            : Dietmar Ruhmann (DR), Martin Bauer Services
* Date              : 03.03.2016
* NetWeaver Release : 7.4
* ------------------------------------------------------------------- *
* History of Change
* 03.03.2016 | DR | initial created
* ------------------------------------------------------------------- *

REPORT zca_testdr1.

DATA: o_zebra TYPE REF TO zcl_ca_zeb_tools.
DATA: o_zebra_data TYPE REF TO zcl_ca_zeb_data.

DATA: lf_device   TYPE rspolname,
      lf_length   TYPE dzbd2p,
      lf_width    TYPE dzbd2p,
      lf_rotate   TYPE char1,
      lf_y        TYPE dzbd2p,
      lt_zeb_data TYPE zca_zeb_data_tt.
FIELD-SYMBOLS: <zz> LIKE LINE OF lt_zeb_data.

* data determination
o_zebra_data = NEW #( ).
o_zebra_data->get_qm_data( EXPORTING if_phynr = '000100001782'
                           IMPORTING et_zeb_data = lt_zeb_data ) .

* Create object for print job
o_zebra = NEW #( ).

lf_device = 'VG_7'.   " Shortname of Spoolname from SPAD
lf_length = 5.        " Label length in cm
lf_width = 10.        " Label width in cm
lf_rotate = abap_false. " X if you want to rotate the print 180 degrees
lf_y = 1.               " Start value for y coordinate

* initialization
o_zebra->init( if_device = lf_device
               if_length = lf_length
               if_width = lf_width
               if_rotate = lf_rotate ).

" inspection lot -----------------------------------------------------------
READ TABLE lt_zeb_data WITH KEY fieldname = 'PLOS' ASSIGNING <zz>.
IF <zz>-ddtext IS NOT INITIAL.
  o_zebra->print_text( if_text = 'Prüflos:'
                       if_x = 1
                       if_y = lf_y
                       if_fontid = '0'
                       if_fontx = '0.25'
                       if_fonty = '0.25'
                       if_rotate = '0' ).

  o_zebra->print_text( if_text = <zz>-ddtext
                        if_x = '2.8'
                        if_y = lf_y
                        if_fontid = '0'
                        if_fontx = '0.25'
                        if_fonty = '0.25'
                        if_rotate = '0' ).
ENDIF.

" material -----------------------------------------------------------
READ TABLE lt_zeb_data WITH KEY fieldname = 'MATNR' ASSIGNING <zz>.
IF <zz>-ddtext IS NOT INITIAL.
  lf_y = lf_y + '0.3'.
  o_zebra->print_text( if_text = 'Material:'
                        if_x = 1
                        if_y = lf_y
                        if_fontid = '0'
                        if_fontx = '0.25'
                        if_fonty = '0.25'
                        if_rotate = '0' ).


  o_zebra->print_text( if_text = <zz>-ddtext
                        if_x = '2.8'
                        if_y = lf_y
                        if_fontid = '0'
                        if_fontx = '0.25'
                        if_fonty = '0.25'
                        if_rotate = '0' ).
ENDIF.

" Batch   -----------------------------------------------------------
READ TABLE lt_zeb_data WITH KEY fieldname = 'CHARG' ASSIGNING <zz>.
IF <zz>-ddtext IS NOT INITIAL.
lf_y = lf_y + '0.3'.
o_zebra->print_text( if_text = 'Charge:'
                      if_x = 1
                      if_y = lf_y
                      if_fontid = '0'
                      if_fontx = '0.25'
                      if_fonty = '0.25'
                      if_rotate = '0' ).


o_zebra->print_text( if_text = <zz>-ddtext
                      if_x = '2.8'
                      if_y = lf_y
                      if_fontid = '0'
                      if_fontx = '0.25'
                      if_fonty = '0.25'
                      if_rotate = '0' ).
endif.

" Barcode 39 ---------------------------------------------------------
o_zebra->print_code_39( if_text = '000100001782'
                        if_x = 1
                        if_y = 3
                        if_rotate = '0'
                        if_check = 'N'
                        if_prtvalue = 'Y'
                        if_height = '1'
                        if_width = '4'
                        if_widthratio = '2.2' ) .

" submit to spooler
o_zebra->print( if_copy = 1
                if_title = 'Label Testprint from ZCA_TESTDR1').
