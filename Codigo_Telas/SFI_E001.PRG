/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_E001.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Mala Direta - Clientes
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL lin_:={}, i_, ct_, dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=21, l_i:=14, c_i:=64, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±± Mala Direta - Clientes ±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú C¢digo dos Clientes ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³       de :           at‚ :           ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
codigoi=0                                                    // C¢digo
codigof=0                                                    // C¢digo
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+15 GET  codigoi;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(codigoi,04,00),'CLIENTES',1)~Necess rio informar C¢digo")
                    DEFAULT "1"
                    AJUDA "Informe o c¢digo do CLiente"
                    CMDF8 "VDBF(6,5,20,77,'CLIENTES',{'codigo','razao','cgc_rg'},1,'codigo',[])"

   @ l_s+04 ,c_s+31 GET  codigof;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(codigof,04,00),'CLIENTES',1)~Necess rio informar C¢digo")
                    DEFAULT "9999"
                    AJUDA "Informe o c¢digo do CLiente"
                    CMDF8 "VDBF(6,5,20,77,'CLIENTES',{'codigo','razao','cgc_rg'},1,'codigo',[])"

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA()
      LOOP
   ENDI
   IF LASTKEY()=K_ESC                                        // se quer cancelar
      RETU                                                   // retorna
   ENDI

   #ifdef COM_REDE
      IF !USEARQ("CLIENTES",.f.,10,1)                        // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("CLIENTES")                                     // abre o dbf e seus indices
   #endi

   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF TYPE("drvfi_e001")="C"                                 // conf da etq alterada?
      qtlin_=VAL(SUBS(drvfi_e001, 1,3))                      // linhas da etiqueta
      qtcol_=VAL(SUBS(drvfi_e001, 4,3))                      // largura da etiqueta
      qtcse_=VAL(SUBS(drvfi_e001, 7,3))                      // espaco entre as carreiras
      qtcar_=VAL(SUBS(drvfi_e001,10,3))                      // numero de carreiras
      qtreg_=SUBS(drvfi_e001,13)                             // qtde por registro
   ELSE                                                      // se nao alterou pega
      qtlin_=6                                               // 'defaults` da qde linhas
      qtcol_=60                                              // largura da etiqueta
      qtcse_=0                                               // espaco entre as carreiras
      qtcar_=1                                               // numero de carreiras
      qtreg_="1"                                             // qtde por registro
   ENDI
   IF !opcoes_etq(lin_menu,col_menu,6,44,52)                 // nao quis configurar...
      CLOS ALL                                               // fecha arquivos e
      LOOP                                                   // volta ao menu
   ENDI
   lin_=ARRAY(qtlin_)                                        // inicializa vetor de linhas
   IF tps=2                                                  // se vai para arquivo/video
      arq_=ARQGER()                                          // entao pega nome do arquivo
      IF EMPTY(arq_)                                         // se cancelou ou nao informou
         LOOP                                                // retorna
      ENDI
   ELSE
      arq_=drvporta                                          // porta de saida configurada
   ENDI
   SET PRINTER TO (arq_)                                     // redireciona saida
   EXIT
ENDD
IF !EMPTY(drvtapg)                                           // existe configuracao de tam pag?
   op_=AT("NNN",drvtapg)                                     // se o codigo que altera
   IF op_=0                                                  // o tamanho da pagina
      msg="Configura‡„o do tamanho da p gina!"               // foi informado errado
      DBOX(msg,,,,,"ERRO!")                                  // avisa
      CLOSE ALL                                              // fecha todos arquivos abertos
      RETU                                                   // e cai fora...
   ENDI                                                      // codigo para setar/resetar tam pag
   lpp_006=LEFT(drvtapg,op_-1)+"006"+SUBS(drvtapg,op_+3)
   lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
   lpp_006:=lpp_066 :=""                                     // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SET CONSOLE OFF                                              // desliga impressao no video
SET PRINT ON                                                 // e envia para impressora
IMPCTL(lpp_006)                                              // seta pagina com 6 linhas
IMPCTL(drvpcom)                                              // comprime os dados
IF tps=2
   IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
      DO WHIL !EOF()
         AFILL(lin_,""); ct_=0                               // inicializa lin_/contador de carreiras
         DO WHILE !EOF() .AND. ct_<qtcar_                    // faz todas as carreiras
            #ifdef COM_TUTOR
               IF IN_KEY()=K_ESC                             // se quer cancelar
            #else
               IF INKEY()=K_ESC                              // se quer cancelar
            #endi
               IF canc()                                     // pede confirmacao
                  BREAK                                      // confirmou...
               ENDI
            ENDI
            IF codigo>=M->codigoi.and.codigo<=M->codigof     // se atender a condicao...
               FOR t_=1 TO &qtreg_.                          // repete a mesma n vezes
                  ct_++                                      // soma contador de carreiras
                  lin_[1]+="  "+razao+SPAC(qtcol_+qtcse_-37)
                  lin_[2]+="  "+ender+", "+TRAN(numero,"99999")+SPAC(qtcol_+qtcse_-44)
                  lin_[3]+="  "+compl+SPAC(qtcol_+qtcse_-17)
                  lin_[4]+="  "+bairro+SPAC(qtcol_+qtcse_-22)
                  lin_[5]+="  "+cidade+" - "+TRAN(uf,"!!")+SPAC(qtcol_+qtcse_-27)
                  lin_[6]+="  C E P : "+TRAN(cep,"@R 99999-999")+SPAC(qtcol_+qtcse_-19)
                  IF ct_>=qtcar_                             // atingiu o numero de carreiras?
                     ?? CHR(13)
                     FOR i_=1 TO qtlin_                      // imprime linhas da etiqueta
                        ?? lin_[i_]
                        IF EMPTY(drvtapg) .OR. i_<qtlin_
                           ?
                        ENDI
                     NEXT
                     IF !EMPTY(drvtapg)                      // existe configuracao de tam pag?
                        EJEC                                 // salta pagina no inicio
                     ENDI
                     AFILL(lin_,""); ct_=0                   // inicializa lin_/contador de carreiras
                  ENDI
               NEXT
               SKIP                                          // pega proximo registro
            ELSE                                             // se nao atende condicao
               SKIP                                          // pega proximo registro
            ENDI
         ENDD                                                // eof ou encheu todas as carreiras
         IF ct_>0                                            // preenchido a carreira parcialmente
            ?? CHR(13)
            FOR i_=1 TO qtlin_                               // imprime linhas da etiqueta
               ?? lin_[i_]
               IF EMPTY(drvtapg) .OR. i_<qtlin_
                  ?
               ENDI
            NEXT
            IF !EMPTY(drvtapg)                               // existe configuracao de tam pag?
               EJEC                                          // salta pagina no inicio
            ENDI
         ENDI
      ENDD
   ENDD ccop
   IF EMPTY(drvtapg)
      EJEC                                                   // salta pagina no inicio
   ENDI
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
IMPCTL(lpp_066)                                              // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET CONSOLE ON                                               // liga impressao em video
SET PRINT OFF                                                // e desliga a impresora
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
SET CONSOLE ON                                               // liga impressao em video
SET PRINT OFF                                                // e desliga a impresora
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

* \\ Final de SFI_E001.PRG
