#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function L14E02
    Rotina automática de alteração de dados dos clientes com MVC
    @type  Function
    @author Vinícius Silva
    @since 05/05/2023
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=604230458
    @see https://tdn.totvs.com/display/public/PROT/DT+Ajuste+F12+CRMA980
/*/
User Function L14E02()
    Local oModel := NIL
    Private lMsErroAuto := .F.
  
    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    SA1->(DbSetOrder(1))

    if SA1->(DbSeek(FwFilial('SA1') + 'L14E01' + '01'))
        oModel := FwLoadModel('CRMA980')
        oModel:SetOperation(MODEL_OPERATION_UPDATE)
        oModel:Activate()
     
        oModel:SetValue('SA1MASTER', 'A1_END', 'ENDEREÇO ALTERADO')
        oModel:SetValue('SA1MASTER', 'A1_TEL', '(99)9999-9999' )
        
        if oModel:VldData()
            oModel:CommitData()
            MsgInfo('Processo concluído!', 'ALTERADO')
        else
            VarInfo('', oModel:GetErrorMessage())
        endif
        
        oModel:DeActivate()
    else
        MsgInfo('REGISTRO NÃO ENCONTRADO!', 'Atenção')
    endif 

Return
