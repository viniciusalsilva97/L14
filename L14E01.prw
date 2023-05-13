#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'

User Function L14E01()
    Local aDados := {}
    Local nOper  := 3
    Private lMsErroAuto := .F.

    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    Aadd(aDados, {'A1_FILIAL', FwFilial('SA1')  , NIL})
    Aadd(aDados, {'A1_COD'   , 'L14E01'         , NIL})
    Aadd(aDados, {'A1_LOJA'  , '01'             , NIL})
    Aadd(aDados, {'A1_NOME'  , 'EXERCÍCIO 14'   , NIL})
    Aadd(aDados, {'A1_NREDUZ', 'DEU CERTO'      , NIL})
    Aadd(aDados, {'A1_END'   , 'RUA DOS TESTES' , NIL})
    Aadd(aDados, {'A1_TIPO'  , 'F'              , NIL})
    Aadd(aDados, {'A1_EST'   , 'SP'             , NIL})
    Aadd(aDados, {'A1_MUN'   , 'RIBEIRAO PRETO' , NIL})
    Aadd(aDados, {'A1_TEL'   , '(11)1111-1111'  , NIL})

    MSExecAuto({|x, y| MATA030(x, y)}, aDados, nOper) 
  
    if lMsErroAuto
        MostraErro()
    endif
Return 
