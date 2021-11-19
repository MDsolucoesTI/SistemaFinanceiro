/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: MOVIM.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Gerenciador do subsistema de movimentos financeiros
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"MOVIM")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]                  // se usuario nao tem permissao,
   ALERTA()                                                  // entao, beep, beep, beep
   DBOX(msg_auto,,,3)                                        // lamentamos e
   RETU                                                      // retornamos ao menu
ENDI
cn:=fgrep :=.f.

#ifdef COM_LOCK
   IF LEN(pr_ok)>0                                           // se a protecao acusou
      ? pr_ok                                                // erro, avisa e
      QUIT                                                   // encerra a aplicacao
   ENDI
#endi

t_fundo=SAVESCREEN(0,0,MAXROW(),79)                          // salva tela do fundo
op_cad=1
DO WHIL op_cad!=0
   criterio=""
   RESTSCREEN(,0,MAXROW(),79,t_fundo)                        // restaura tela do fundo
   cod_sos=5 ; cn=.f.
   CLEA TYPEAHEAD                                            // limpa o buffer do teclado
   fgrep=.f.
   SET KEY K_F3 TO                                           // retira das teclas F3 e F4 as
   SET KEY K_F4 TO                                           // funcoes de repeticao e confirmacao
   msg="Inclus„o|"+;
       "Manuten‡„o|"+;
       "Consulta"
   op_cad=DBOX(msg,lin_menu,col_menu,E_MENU,NAO_APAGA,,,,op_cad)
   IF op_cad!=0                                              // se escolheu uma opcao
      Tela_fundo=SAVESCREEN(0,0,MAXROW(),79)                 // salva a tela para ROLATELA()
      SELE A                                                 // e abre o arquivo e seus indices

      #ifdef COM_REDE
         IF !USEARQ(sistema[op_sis,O_ARQUI],.f.,20,1)        // se falhou a abertura do
            RETU                                             // arquivo volta ao menu anterior
         ENDI
      #else
         USEARQ(sistema[op_sis,O_ARQUI])
      #endi

      SET KEY K_F9 TO veoutros                               // habilita consulta em outros arquivos
   ENDI
   DO CASE
      CASE op_cad=01                                         // inclus„o
         op_menu=INCLUSAO
         IF AT("D",exrot[op_sis])=0                          // se usuario pode fazer inclusao
            MOV_INCL()                                       // neste arquivo chama prg de inclusao
         ELSE                                                // caso contrario vamos avisar que
            ALERTA()                                         // ele nao tem permissao para isto
            DBOX(msg_auto,,,3)
         ENDI

      CASE op_cad=02                                         // manuten‡„o
         op_menu=ALTERACAO
         cod_sos=7
         EDIT()

      CASE op_cad=03                                         // consulta
         op_menu=PROJECOES
         cod_sos=8
         EDITA(3,3,MAXROW()-2,77)

   ENDC
   SET KEY K_F9 TO                                           // F9 nao mais consultara outros arquivos
   CLOS ALL                                                  // fecha todos arquivos abertos
ENDD
RETU

PROC MOV_incl     // inclusao no arquivo MOVIM
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, tem_borda, criterio:="", cpord:=""
FOR i=1 TO FCOU()                                            // cria/declara privadas as
   msg=FIEL(i)                                               // variaveis de memoria com
   PRIV &msg.                                                // o mesmo nome dos campos
NEXT                                                         // do arquivo
AFILL(rep,"")
t_f3_=SETKEY(K_F3,{||rep()})                                 // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})                                // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})                         // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
DO WHIL cabem>0
   cod_sos=6
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE MOVIM
   GO BOTT                                                   // forca o
   SKIP                                                      // final do arquivo
   
   /*
      cria variaveis de memoria identicas as de arquivo, para inclusao
      de registros
   */
   FOR i=1 TO FCOU()
      msg=FIEL(i)
      M->&msg.=IF(fgrep.AND.!EMPT(rep[1]),rep[i],&msg.)
   NEXT
   DISPBEGIN()                                               // apresenta a tela de uma vez so
   MOV_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/MOVIM->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   MOV_GET1(INCLUI)                                          // recebe campos
   SELE MOVIM
   IF LASTKEY()=K_ESC                                        // se cancelou
      cabem=0
      LOOP
   ENDI

   #ifdef COM_REDE
      GO BOTT                                                // vamos bloquear o final do
      SKIP                                                   // arq para que nehum outro
      BLOREG(0,.5)                                           // usuario possa incluir
   #endi

   APPEND BLANK                                              // inclui reg em branco no dbf
   FOR i=1 TO FCOU()                                         // para cada campo,
      msg=FIEL(i)                                            // salva o conteudo
      rep[i]=M->&msg.                                        // para repetir
      REPL &msg. WITH rep[i]                                 // enche o campo do arquivo
   NEXT

   #ifdef COM_REDE
      UNLOCK                                                 // libera o registro e
      COMMIT                                                 // forca gravacao
   #else
      IF RECC()-INT(RECC()/20)*20=0                          // a cada 20 registros
         COMMIT                                              // digitados forca gravacao
      ENDI
   #endi

   ult_reg=RECN()                                            // ultimo registro digitado
ENDD
GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                           // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC MOV_tela     // tela do arquivo MOVIM
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±±±±±±±±± Movimentos Financeiros ±±±±±±±±±±±±±±±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Data ÄÄÄÄÄÄÂ Documento ÄÄÄÄÄÄÂ A‡„o Financeira ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³            ³                 ³     -                                    ³"
@ l_s+05,c_s+1 SAY " Ã Caixa/Banco ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÂ Tipo ÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ l_s+06,c_s+1 SAY " ³   -                               ³         ³"
@ l_s+07,c_s+1 SAY " Ã Hist¢rico Padr„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ Complemento do Hist¢rico ÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+08,c_s+1 SAY " ³    -                              ³                                     ³"
@ l_s+09,c_s+1 SAY " Ã Valor ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Centro de Custo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+10,c_s+1 SAY " ³                         ³     -                                         ³"
@ l_s+11,c_s+1 SAY " Ã Observa‡„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ l_s+12,c_s+1 SAY " ³                                                    ³"
@ l_s+13,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
RETU

PROC MOV_gets     // mostra variaveis do arquivo MOVIM
LOCAL getlist := {}
MOV_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(STR(CONTAS,04,00),'CONTAS',1)
PTAB(STR(BANCO,02,00),'BANCOS',1)
PTAB(STR(HISTORICO,03,00),'HISTO',1)
PTAB(STR(CUSTO,04,00),'CUSTO',1)
@ l_s+04 ,c_s+04 GET  data;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+04 ,c_s+17 GET  documen;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+04 ,c_s+35 GET  contas;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"3")

@ l_s+06 ,c_s+04 GET  banco;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,04,O_CRIT],,"2")

@ l_s+06 ,c_s+40 GET  tipo;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,05,O_CRIT],,"1")

@ l_s+08 ,c_s+04 GET  historico;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"5")

@ l_s+08 ,c_s+40 GET  complem;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+10 ,c_s+04 GET  valor;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+10 ,c_s+30 GET  custo;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,09,O_CRIT],,"4")

@ l_s+12 ,c_s+04 GET  obs

CLEAR GETS
RETU

PROC MOV_get1     // capta variaveis do arquivo MOVIM
LOCAL getlist := {}
PRIV  blk_movim:=.t.
PARA tp_mov
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+04 ,c_s+04 GET  data;
                       PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                       DEFINICAO 1

      @ l_s+04 ,c_s+17 GET  documen;
                       PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                       DEFINICAO 2

      @ l_s+04 ,c_s+35 GET  contas;
                       PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                       DEFINICAO 3
                       MOSTRA sistema[op_sis,O_FORMULA,3]

      @ l_s+06 ,c_s+04 GET  banco;
                       PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                       DEFINICAO 4
                       MOSTRA sistema[op_sis,O_FORMULA,2]

      @ l_s+06 ,c_s+40 GET  tipo;
                       PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                       DEFINICAO 5
                       MOSTRA sistema[op_sis,O_FORMULA,1]

      @ l_s+08 ,c_s+04 GET  historico;
                       PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                       DEFINICAO 6
                       MOSTRA sistema[op_sis,O_FORMULA,5]

      @ l_s+08 ,c_s+40 GET  complem;
                       PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                       DEFINICAO 7

      @ l_s+10 ,c_s+04 GET  valor;
                       PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                       DEFINICAO 8

      @ l_s+10 ,c_s+30 GET  custo;
                       PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                       DEFINICAO 9
                       MOSTRA sistema[op_sis,O_FORMULA,4]

      @ l_s+12 ,c_s+04 GET  obs
                       DEFINICAO 10

      READ
      SET KEY K_ALT_F8 TO
      IF rola_t
         ROLATELA()
         LOOP
      ENDI
      IF LASTKEY()!=K_ESC .AND. drvincl .AND. op_menu=INCLUSAO
         IF !CONFINCL()
            LOOP
         ENDI
      ENDI
      EXIT
   ENDD
ENDI
PTAB(STR(CONTAS,04,00),'CONTAS',1)
PTAB(STR(BANCO,02,00),'BANCOS',1)
PTAB(STR(HISTORICO,03,00),'HISTO',1)
PTAB(STR(CUSTO,04,00),'CUSTO',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
   IF !EMPTY(codlan) .AND. tp_mov=EXCLUI
      ALERTA()   // existe registro validado aqui!
      msg="Registro de Lan‡amento"
      DBOX(msg,,,,,"IMPOSS¡VEL EXCLUIR!")
   ELSE

      #ifdef COM_REDE
         REPBLO('BANCOS->saldoatu',{||If(tipo=[E],BANCOS->saldoatu-valor,BANCOS->saldoatu+valor)})
         IF !Empty(custo).And.tipo=[E]
            REPBLO('CUSTO->receita',{||CUSTO->receita-valor})
         ENDI
         IF !Empty(custo).And.tipo=[S]
            REPBLO('CUSTO->despesa',{||CUSTO->despesa-valor})
         ENDI
      #else
         REPL BANCOS->saldoatu WITH If(tipo=[E],BANCOS->saldoatu-valor,BANCOS->saldoatu+valor)
         IF !Empty(custo).And.tipo=[E]
            REPL CUSTO->receita WITH CUSTO->receita-valor
         ENDI
         IF !Empty(custo).And.tipo=[S]
            REPL CUSTO->despesa WITH CUSTO->despesa-valor
         ENDI
      #endi

      MANUREF(STR(CONTAS,04,00),'CONTAS',1,DECREMENTA)
      MANUREF(STR(BANCO,02,00),'BANCOS',1,DECREMENTA)
      MANUREF(STR(HISTORICO,03,00),'HISTO',1,DECREMENTA)
      MANUREF(STR(CUSTO,04,00),'CUSTO',1,DECREMENTA)
      DELE
   ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF !EMPTY(codlan) .AND. tp_mov=RECUPERA
         ALERTA()// existe registro validado aqui!
         msg="Registro de Lan‡amento"
         DBOX(msg,,,,,"IMPOSS¡VEL RECUPERAR!")
      ELSE
         IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (CONTAS->(DELE()) .OR. BANCOS->(DELE()) .OR. HISTO->(DELE()) .OR. CUSTO->(DELE()))
            msg=""
            IF CONTAS->(DELE())
               msg="|"+sistema[EVAL(qualsis,"CONTAS"),O_MENU]
            ENDI
            IF BANCOS->(DELE())
               msg+="|"+sistema[EVAL(qualsis,"BANCOS"),O_MENU]
            ENDI
            IF HISTO->(DELE())
               msg+="|"+sistema[EVAL(qualsis,"HISTO"),O_MENU]
            ENDI
            IF CUSTO->(DELE())
               msg+="|"+sistema[EVAL(qualsis,"CUSTO"),O_MENU]
            ENDI
            ALERTA(2)
            DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
         ELSE

            #ifdef COM_REDE
               REPBLO('BANCOS->saldoatu',{||If(tipo=[E],BANCOS->saldoatu+valor,BANCOS->saldoatu-valor)})
               REPBLO('BANCOS->datmov',{||data})
               IF !Empty(custo).And.tipo=[E]
                  REPBLO('CUSTO->receita',{||CUSTO->receita+valor})
               ENDI
               IF !Empty(custo).And.tipo=[S]
                  REPBLO('CUSTO->despesa',{||CUSTO->despesa+valor})
               ENDI
            #else
               REPL BANCOS->saldoatu WITH If(tipo=[E],BANCOS->saldoatu+valor,BANCOS->saldoatu-valor)
               REPL BANCOS->datmov WITH data
               IF !Empty(custo).And.tipo=[E]
                  REPL CUSTO->receita WITH CUSTO->receita+valor
               ENDI
               IF !Empty(custo).And.tipo=[S]
                  REPL CUSTO->despesa WITH CUSTO->despesa+valor
               ENDI
            #endi

            MANUREF(STR(CONTAS,04,00),'CONTAS',1,INCREMENTA)
            MANUREF(STR(BANCO,02,00),'BANCOS',1,INCREMENTA)
            MANUREF(STR(HISTORICO,03,00),'HISTO',1,INCREMENTA)
            MANUREF(STR(CUSTO,04,00),'CUSTO',1,INCREMENTA)
            IF op_menu!=INCLUSAO
               RECA
            ENDI
         ENDI
      ENDI
   ENDI
ENDI
RETU

* \\ Final de MOVIM.PRG
