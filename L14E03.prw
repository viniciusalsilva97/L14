#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'

#DEFINE EXCLUIR 5

/*/{Protheus.doc} User Function L14E03
    Rotina automática para excluir um fornecedor
    @type  Function
    @author Vinícius Silva
    @since 05/05/2023
/*/
User Function L14E03()
    Local aDados := {}
    Private lMsErroAuto := .F.

    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    Aadd(aDados, {'A2_COD', '010201', NIL})

    MSExecAuto({|x, y| MATA020(x, y)}, aDados, EXCLUIR) 

    if lMsErroAuto
        MostraErro()
    endif
Return 
