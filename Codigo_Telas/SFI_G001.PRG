/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_G001.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Gr fico
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, sgr_dad:={}, qt_2, iii, arq_, arqsgr_, qt_1, ii
PARA  lin_menu, col_menu
arqsgr_=drvdbf+"G"+ide_maq+".039"
arq_=drvdbf+"SGR"+ide_maq+".par"                             // nome do arquivo de parametro do SGR

#ifndef COM_TUTOR
   IF FILE(arqsgr_)
      cod_sos=58
      msgt="EXISTEM ESPECIFICA€™ES|DESTE GRFICO!"
      msg="Utilizar|Recalcular"
      i=DBOX(msg,,,E_MENU,,msgt)
      IF i=1
         COPY FILE (arqsgr_) TO (arq_)
         SGRAFICO(GRAFICO)                                   // ativa o SGR atraves de interrupt
         ERASE (arq_)                                        // eclui arquivo .par do SGR
         RETU
      ENDI
   ENDI
#endi

nucop=1

#ifdef COM_REDE
   IF !USEARQ("CUSTO",.f.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("CUSTO")                                           // abre o dbf e seus indices
#endi

resolucao=100
cor_col=.t.
titrel="Posi‡„o Financeira"
criterio:=cpord := ""                                        // inicializa variaveis
chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_sgr(lin_menu,col_menu,57)                         // nao quis configurar...
   CLOS ALL                                                  // fecha arquivos e
   RETU                                                      // volta ao menu
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
BEGIN SEQUENCE
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      #ifdef COM_TUTOR
         IF IN_KEY()=K_ESC                                   // se quer cancelar
      #else
         IF INKEY()=K_ESC                                    // se quer cancelar
      #endi
         IF canc()                                           // pede confirmacao
            BREAK                                            // confirmou...
         ENDI
      ENDI
      qb06901=codigo                                         // campo para agrupar 1a quebra
      AADD(sgr_dad,{codigo,{}})                              // procura quebra no vetor tit das quebras
      qt_1=LEN(sgr_dad)
      AADD(sgr_dad[qt_1,2],{"Receita",0})
      AADD(sgr_dad[qt_1,2],{"Despesa",0})
      AADD(sgr_dad[qt_1,2],{"Receber",0})
      AADD(sgr_dad[qt_1,2],{"Rec Venc",0})
      AADD(sgr_dad[qt_1,2],{"Pagar",0})
      AADD(sgr_dad[qt_1,2],{"Pag Venc",0})
      DO WHIL !EOF() .AND. codigo=qb06901
         #ifdef COM_TUTOR
            IF IN_KEY()=K_ESC                                // se quer cancelar
         #else
            IF INKEY()=K_ESC                                 // se quer cancelar
         #endi
            IF canc()                                        // pede confirmacao
               BREAK                                         // confirmou...
            ENDI
         ENDI
         sgr_dad[qt_1,2,01,2]+=receita                       // acumula no vetor
         sgr_dad[qt_1,2,02,2]+=despesa
         sgr_dad[qt_1,2,03,2]+=receber
         sgr_dad[qt_1,2,04,2]+=recebvenc
         sgr_dad[qt_1,2,05,2]+=pagar
         sgr_dad[qt_1,2,06,2]+=pagovenc
         SKIP                                                // pega proximo registro
      ENDD
   ENDD
   SET ALTE TO (arqsgr_)                                     // abre o arquivo para gravacao
   SET ALTE ON                                               // liga gravacao
   SET CONS OFF                                              // nao iremos exibir na tela
   IF EMPTY(titrel)                                          // se nao definiu um titulo
      ?? "Titulo = Posi‡„o Financeira"                       // pegaremos o default
   ELSE                                                      // caso contrario
      ?? "Titulo = "+titrel                                  // usaremos o titulo definido
   ENDI
   ? "Tipo = 6 "
   ? "Titulo X = Centros de Custo"
   ? "Titulo Y = Valores"
   ? "Porta = "+drvporta
   IF !cor_col
      ? "Pintar areas = NAO"
   ENDI
   IF !EMPTY(drvland)                                        // prn matricial nao tem resolucao
      ? "Resolucao = "+STR(resolucao)
   ENDI
   ? "Posicao do titulo = Esquerdo"
   ? "Tipo da Grade = 1"
   qt_1=LEN(sgr_dad)                                         // quantidade de colunas
   qt_2=LEN(sgr_dad[1,2])                                    // quantidade de linhas
   ? "Quantidade Linhas = "+LTRIM(STR(qt_2))
   ? "Quantidade Colunas = "+LTRIM(STR(qt_1))
   ? "[DADOS]"
   IF qt_1>0 .AND. qt_2>0
      ? ""
      FOR ii=1 TO qt_1                                       // grava os titulos
         ?? CHR(34)+ALLTRIM(TRAN(sgr_dad[ii,1],""))+CHR(34)+IF(ii=qt_1,"",",")
      NEXT
      FOR ii=1 TO qt_2                                       // grava os dados de cada linha
         ? ""
         ?? CHR(34)+ALLTRIM(TRAN(sgr_dad[1,2,ii,1],""))+CHR(34)+","
         FOR iii=1 TO qt_1
            ?? LTRIM(TRAN(sgr_dad[iii,2,ii,2],""))           // grava o dado
            IF iii!=qt_1                                     // se nao for a ultima coluna
               ?? ","                                        // grava o delimitador
            ENDI
         NEXT
      NEXT
   ENDI
   ? ""
   SET ALTE OFF                                              // desliga a gravacao
   SET ALTE TO                                               // fecha arquivo
   SET CONS ON                                               // reabilita o video
   COPY FILE (arqsgr_) TO (arq_)
   SGRAFICO(GRAFICO)                                         // ativa o SGR atraves de interrupt
   ERASE (arq_)                                              // eclui arquivo .par do SGR
END SEQUENCE
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

* \\ Final de SFI_G001.PRG
