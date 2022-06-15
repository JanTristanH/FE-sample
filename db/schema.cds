namespace db;


entity NAST {
        //missing fields:
        //    - mandt
        //    - _DATAAGING
    key DOC_ID           : String(32);
        PDOC_ID          : String(32);
        MOVIND           : String(1);
        PSTYPE           : String(40)        @title :                   '{i18n>ItemCategory}';
        PSART            : String(40);
        DOCNR            : String(40);
        DOCPOSNR         : String(40);
        DOCTYPE          : String(40);
        DOCAPPL          : String(40);
        RDOCNR           : String(40);
        RDOCPOSNR        : String(40);
        RDOCTYPE         : String(40);
        KUNWE            : String(40);
        MATNR            : String(40)        @title :                   '{i18n>MaterialName}';
        BWTAR            : String(40);
        OIHANTYP         : String(40);
        DOCQTY           : Decimal(7, 3);
        DOCUOM           : String(40);
        WERKS            : String(40);
        LGORT            : String(40);
        VKORG            : String(40);
        VTWEG            : String(40);
        SPART            : String(40);
        MDMM             : String(40);
        MDMM_DOCQTY      : String(40);
        MDMM_DOCUOM      : String(40);
        TDLVZN           : String(40);
        DLVZN            : String(40)        @title :                   '{i18n>DeliveryZone}';
        IDMDOCTYPE       : String(40);
        PDLVDF           : String(40)        @title :                   '{i18n>PlannedDateFr}'; //Date
        PDLVDT           : String(40); //Date;
        PDLVTF           : Time;
        PDLVTT           : Time;
        IDLVDF           : String(40); //Date;
        IDLVTF           : Time;
        BU_PARTNER       : String(40);
        NOTE_DRV         : String(40);
        NOTE_DSP         : String(40);
        PRIORITY         : String(40);
        COLL_ORD_ID      : String(40);
        KTMNG            : String(40);
        KDATB            : String(40);
        KDATE            : String(40); //Date;
        ERNAM            : String(12)        @title :                   '{i18n>CreatedBy}';
        CHGTST           : Decimal(21, 7);
        FLAG_NEW         : String(1);
        FLAG_UPD         : String(1);
        FLAG_DEL         : String(1);
        GEOLON           : Decimal(15, 12);
        GEOLAT           : Decimal(15, 12);
        DummyForCounting : Integer default 1 @UI.HiddenFilter  @title : '{i18n>Count}';

}
