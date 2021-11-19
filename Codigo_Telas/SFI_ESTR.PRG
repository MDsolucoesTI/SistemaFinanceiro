/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_ESTR.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Cria estrutura dos arquivos
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

PROC FOR_estr     // estrutura do arquivo FORNEC
DBCREATE(dbf,{;
               {"codigo"    ,"N",  4, 0},; // 9999
               {"tipo"      ,"C",  1, 0},; // @!
               {"rg"        ,"C", 14, 0},; // @!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"cgc"       ,"C", 14, 0},; // @R 99.999.999/9999-99
               {"inscr"     ,"C", 12, 0},; // @R 999.999.999.999
               {"razao"     ,"C", 35, 0},; // 
               {"profis"    ,"C", 20, 0},; // 
               {"dtnasc"    ,"D",  8, 0},; // @D
               {"nacio"     ,"C", 20, 0},; // 
               {"natu"      ,"C", 20, 0},; // 
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"compl"     ,"C", 15, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"uf"        ,"C",  2, 0},; // !!
               {"fax"       ,"C", 12, 0},; // @R (!999)!!99-9999
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"ramal"     ,"C",  4, 0},; // 
               {"contato"   ,"C", 25, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC CLI_estr     // estrutura do arquivo CLIENTES
DBCREATE(dbf,{;
               {"codigo"    ,"N",  4, 0},; // 9999
               {"tipo"      ,"C",  1, 0},; // @!
               {"codcre"    ,"N",  1, 0},; // 9
               {"rg"        ,"C", 14, 0},; // @!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"cgc"       ,"C", 14, 0},; // @R 99.999.999/9999-99
               {"inscr"     ,"C", 12, 0},; // @R 999.999.999.999
               {"razao"     ,"C", 35, 0},; // 
               {"profis"    ,"C", 20, 0},; // 
               {"dtnasc"    ,"D",  8, 0},; // @D
               {"nacio"     ,"C", 20, 0},; // 
               {"natu"      ,"C", 20, 0},; // 
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"compl"     ,"C", 15, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"uf"        ,"C",  2, 0},; // !!
               {"fax"       ,"C", 12, 0},; // @R (!999)!!99-9999
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"ramal"     ,"C",  4, 0},; // 
               {"contato"   ,"C", 25, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC BAN_estr     // estrutura do arquivo BANCOS
DBCREATE(dbf,{;
               {"codigo"    ,"N",  2, 0},; // 99
               {"codbanco"  ,"C",  3, 0},; // 999
               {"banco"     ,"C", 18, 0},; // @R 999-!!99-!!!!!!!!!-!!
               {"descricao" ,"C", 30, 0},; // 
               {"datmov"    ,"D",  8, 0},; // @D
               {"saldoatu"  ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"valorflag" ,"N", 15, 2},; // @E 999,999,999,999.99
               {"intlan"    ,"C",  8, 0},; // 99999999
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC CON_estr     // estrutura do arquivo CONTAS
DBCREATE(dbf,{;
               {"codigo"    ,"N",  4, 0},; // 9999
               {"descricao" ,"C", 30, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC HIS_estr     // estrutura do arquivo HISTO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  3, 0},; // 999
               {"descri"    ,"C", 35, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC CUS_estr     // estrutura do arquivo CUSTO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  4, 0},; // 9999
               {"departa"   ,"C", 35, 0},; // 
               {"receita"   ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"despesa"   ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"receber"   ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"recebvenc" ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"pagar"     ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"pagovenc"  ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC CRE_estr     // estrutura do arquivo CREDITO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  1, 0},; // 9
               {"tipo"      ,"C", 15, 0},; // @!
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC TIC_estr     // estrutura do arquivo TICHEQUE
DBCREATE(dbf,{;
               {"nubanco"   ,"C",  3, 0},; // 999
               {"colval"    ,"N",  3, 0},; // 999
               {"linval"    ,"N",  3, 0},; // 999
               {"colext"    ,"N",  3, 0},; // 999
               {"linext"    ,"N",  3, 0},; // 999
               {"colord"    ,"N",  3, 0},; // 999
               {"linord"    ,"N",  3, 0},; // 999
               {"colcid"    ,"N",  3, 0},; // 999
               {"colmes"    ,"N",  3, 0},; // 999
               {"colano"    ,"N",  3, 0},; // 999
               {"lincid"    ,"N",  3, 0},; // 999
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC MOV_estr     // estrutura do arquivo MOVIM
DBCREATE(dbf,{;
               {"data"      ,"D",  8, 0},; // @D
               {"documen"   ,"C", 15, 0},; // @!
               {"contas"    ,"N",  4, 0},; // 9999
               {"banco"     ,"N",  2, 0},; // 99
               {"tipo"      ,"C",  1, 0},; // @!
               {"historico" ,"N",  3, 0},; // 999
               {"complem"   ,"C", 35, 0},; // @!
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"custo"     ,"N",  4, 0},; // 9999
               {"obs"       ,"C", 50, 0},; // 
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC PAG_estr     // estrutura do arquivo PAGAR
DBCREATE(dbf,{;
               {"seque"     ,"N", 10, 0},; // 9999999999
               {"data"      ,"D",  8, 0},; // @D
               {"documen"   ,"C", 15, 0},; // @!
               {"codigo"    ,"N",  4, 0},; // 9999
               {"vencimento","D",  8, 0},; // @D
               {"valpagar"  ,"N", 15, 2},; // @E 999,999,999,999.99
               {"contas"    ,"N",  4, 0},; // 9999
               {"banco"     ,"N",  2, 0},; // 99
               {"historico" ,"N",  3, 0},; // 999
               {"custo"     ,"N",  4, 0},; // 9999
               {"obs"       ,"C", 50, 0},; // 
               {"parcelas"  ,"N",  2, 0},; // 99
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"datapago"  ,"D",  8, 0};  // @D
             };
)
RETU

PROC REC_estr     // estrutura do arquivo RECEBER
DBCREATE(dbf,{;
               {"seque"     ,"N", 10, 0},; // 9999999999
               {"data"      ,"D",  8, 0},; // @D
               {"documen"   ,"C", 15, 0},; // @!
               {"codigo"    ,"N",  4, 0},; // 9999
               {"vencimento","D",  8, 0},; // @D
               {"valpagar"  ,"N", 15, 2},; // @E 999,999,999,999.99
               {"contas"    ,"N",  4, 0},; // 9999
               {"banco"     ,"N",  2, 0},; // 99
               {"historico" ,"N",  3, 0},; // 999
               {"custo"     ,"N",  4, 0},; // 9999
               {"obs"       ,"C", 50, 0},; // 
               {"parcelas"  ,"N",  2, 0},; // 99
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"datapago"  ,"D",  8, 0};  // @D
             };
)
RETU

PROC CHE_estr     // estrutura do arquivo CHEQUES
DBCREATE(dbf,{;
               {"seque"     ,"N", 10, 0},; // 9999999999
               {"inter"     ,"C",  1, 0},; // @!
               {"codigo"    ,"N",  4, 0},; // 9999
               {"documen"   ,"C", 15, 0},; // @!
               {"vencimento","D",  8, 0},; // @D
               {"codbanco"  ,"N",  2, 0},; // 99
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"emissao"   ,"D",  8, 0},; // @D
               {"favorecido","C", 40, 0},; // @!
               {"acao"      ,"N",  4, 0},; // 9999
               {"histo"     ,"N",  3, 0},; // 999
               {"complem"   ,"C", 35, 0};  // @!
             };
)
RETU

PROC PAR_estr     // estrutura do arquivo PARAMET
DBCREATE(dbf,{;
               {"empresa1"  ,"C", 35, 0},; // 
               {"cgc1"      ,"C", 14, 0},; // @R 99.999.999/9999-99
               {"inscr1"    ,"C", 12, 0},; // @R 999.999.999.999
               {"ender1"    ,"C", 35, 0},; // 
               {"numero1"   ,"C",  5, 0},; // 99999
               {"bairro1"   ,"C", 18, 0},; // 
               {"cidade1"   ,"C", 20, 0},; // 
               {"uf1"       ,"C",  2, 0},; // @!
               {"pais1"     ,"C", 15, 0},; // 
               {"cep1"      ,"C",  8, 0},; // @R 99999-999
               {"tele1"     ,"C", 12, 0},; // @R (!999)!!99-9999
               {"fax1"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"tex1"      ,"C", 15, 0},; // 
               {"recepcao"  ,"C",  1, 0},; // @!
               {"reserva"   ,"C",  1, 0},; // @!
               {"retaguarda","C",  1, 0},; // @!
               {"restaurant","C",  1, 0},; // @!
               {"estoque"   ,"C",  1, 0},; // @!
               {"financeiro","C",  1, 0},; // @!
               {"orcamen"   ,"C",  1, 0},; // @!
               {"veiculo"   ,"C",  1, 0},; // @!
               {"marina"    ,"C",  1, 0},; // @!
               {"txser"     ,"N",  2, 0},; // 99
               {"numrd"     ,"N",  5, 0},; // 99999
               {"faixaini"  ,"N",  4, 0},; // 9999
               {"faixafim"  ,"N",  4, 0},; // 9999
               {"numreabre" ,"N",  2, 0},; // 99
               {"terdia"    ,"C",  4, 0},; // @R 99:99
               {"bmd"       ,"D",  8, 0},; // @D
               {"hbmd"      ,"C",  4, 0},; // @R 99:99
               {"dtcaixa"   ,"D",  8, 0},; // @D
               {"hcaixa"    ,"C",  4, 0},; // @R 99:99
               {"lancmov"   ,"C",  1, 0},; // !
               {"baixpag"   ,"C",  1, 0},; // !
               {"dtinicont" ,"D",  8, 0},; // @D
               {"dtfimcont" ,"D",  8, 0},; // @D
               {"palavra"   ,"C", 20, 0},; // 
               {"operador1" ,"C", 15, 0};  // 
             };
)
RETU

* \\ Final de SFI_ESTR.PRG
