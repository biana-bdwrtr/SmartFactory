﻿using System;
using System.Data;
using System.Windows.Forms;
using DC00_assm;
using DC00_WinForm;
using Infragistics.Win;
using Infragistics.Win.UltraWinGrid;

namespace KFQS_Form
{
    /// <summary>
    /// Form ID   : MM_StockOut
    /// Form Name : 자재 출고 등록
    /// Date      : 2022-07-05
    /// Maker     : 이기수
    /// </summary>
    public partial class MM_StockOut : DC00_WinForm.BaseMDIChildForm
    {
        #region < Member Area >
        DataTable dtTemp = new DataTable();
        UltraGridUtil _GridUtil = new UltraGridUtil();   // 그리드 세팅 클래스.
        private string sPlantCode = LoginInfo.PlantCode; // 로그인한 공장 정보.

        #endregion

        public MM_StockOut()
        {
            InitializeComponent();
        }

        private void MM_StockOut_Load(object sender, EventArgs e)
        {
            // Grid 세팅.
            _GridUtil.InitializeGrid(this.grid1, false, true, false, "", false);

            // 자재 발주 부분
            _GridUtil.InitColumnUltraGrid(grid1, "CHK",         "선택",        GridColDataType_emu.CheckBox,         80, HAlign.Center, true, true);
            _GridUtil.InitColumnUltraGrid(grid1, "PLANTCODE",   "공장",        GridColDataType_emu.VarChar,         120, HAlign.Left,   true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "MATLOTNO",    "LOTNO",       GridColDataType_emu.VarChar,         160, HAlign.Left,   true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "ITEMCODE",    "품목 코드",   GridColDataType_emu.VarChar,         140, HAlign.Left,   true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "ITEMNAME",    "품목명",      GridColDataType_emu.VarChar,         150, HAlign.Left,   true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "INDATE",      "입고 일자",  GridColDataType_emu.YearMonthDay,     120, HAlign.Left,   true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "WHCODE",      "창고",        GridColDataType_emu.VarChar,         120, HAlign.Left,   true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "STOCKQTY",    "재고 수량",   GridColDataType_emu.Double,          130, HAlign.Right,  true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "BASEUNIT",    "단위",        GridColDataType_emu.VarChar,         130, HAlign.Left,   true, false);

            _GridUtil.InitColumnUltraGrid(grid1, "MAKER",       "생성자",      GridColDataType_emu.VarChar,         130, HAlign.Left,   true, false);
            _GridUtil.InitColumnUltraGrid(grid1, "MAKEDATE",    "생성일자",    GridColDataType_emu.DateTime24,      130, HAlign.Left,   true, false);
            _GridUtil.SetInitUltraGridBind(grid1);

            #region < 콤보박스 세팅 설명 >
            // 콤보박스 세팅.
            // 공장 : 공장에 대한 시스템 공통 코드 내역을 DB에서 가여온다. dtTemp 데이터테이블에 담는다.
            dtTemp = Common.StandardCODE("PLANTCODE");
            // 콤보박스에 받아온 데이터를 벨류멤버와 디스플레이멤버로 표현한다.
            Common.FillComboboxMaster(this.cboPlantCode_H, dtTemp, dtTemp.Columns["CODE_ID"].ColumnName, dtTemp.Columns["CODE_NAME"].ColumnName, "ALL", "");
            // 그리드의 컬럼에 받아온 데이터를 콤보박스 형식으로 세팅한다.
            UltraGridUtil.SetComboUltraGrid(grid1, "PLANTCODE", dtTemp);

            // 창고 코드
            dtTemp = Common.StandardCODE("WHCODE");
            UltraGridUtil.SetComboUltraGrid(grid1, "WHCODE", dtTemp);

            // 품목코드
            // FERT: 완제품 / ROH: 원자재 / HALB: 반제품 / OM: 외주가공품
            dtTemp = Common.Get_ItemCode(new string[] { "ROH" }); // 현 시스템은 원자재만 발주한다고 가정
            Common.FillComboboxMaster(this.cboItemCode_H, dtTemp);
            UltraGridUtil.SetComboUltraGrid(grid1, "ITEMCODE", dtTemp);
            #endregion

            // 공장 로그인 정보로 자동 세팅
            cboPlantCode_H.Value = sPlantCode;

            // 발주 시작 일자 설정.
            dtpStart_H.Value = string.Format("{0:yyyy-MM-01}", DateTime.Now); // 현재 달의 1일로 설정.
            dtpEnd_H.Value   = string.Format("{0:yyyy-MM-dd}", DateTime.Now);
        }

        #region < ToolBar Area >
        public override void DoInquire()
        {
            // 툴바의 조회 버튼 클릭.
            base.DoInquire();
            DBHelper helper = new DBHelper(false);

            try
            {
                string sPlantCode_     = Convert.ToString(cboPlantCode_H.Value);                // 공장
                string sItemCode       = Convert.ToString(cboItemCode_H.Value);                 // 품목 코드
                string sStartDate      = string.Format("{0:yyyy-MM-dd}", dtpStart_H.Value);     // 발주 시작 일자
                string sEndDate        = string.Format("{0:yyyy-MM-dd}", dtpEnd_H.Value);       // 발주 종료 일자
                string sLotNo           = Convert.ToString(txtLotNo_H.Value);                   // 발주 번호

                dtTemp = helper.FillTable("13MM_StockOut_S", CommandType.StoredProcedure
                                          , helper.CreateParameter("@PLANTCODE", sPlantCode_)
                                          , helper.CreateParameter("@ITEMCODE",  sItemCode)
                                          , helper.CreateParameter("@STARTDATE", sStartDate)
                                          , helper.CreateParameter("@ENDDATE",   sEndDate)
                                          , helper.CreateParameter("@MATLOTNO",  sLotNo)
                                          );
                
                // 받아온 데이터를 그리드에 매핑
                if (dtTemp.Rows.Count == 0)
                {
                    // initialize grid
                    _GridUtil.Grid_Clear(grid1);
                    ShowDialog("조회할 데이터가 없습니다.", DialogForm.DialogType.OK);
                    return;
                }

                grid1.DataSource = dtTemp;
                grid1.DataBinds(dtTemp);
            }
            catch (Exception ex)
            {
                ShowDialog(ex.ToString());
            }
            finally
            {
                helper.Close();
            }
        }

        public override void DoSave()
        {
            base.DoSave();

            // 1. 그리드에서 변경된 내역이 있는 행만 추출.
            DataTable dt = grid1.chkChange();
            if (dt is null) return;


            DBHelper helper = new DBHelper("", true);

            try
            {
                // 변경 내역을 저장하시겠습니까?
                if (ShowDialog("변경 내역을 저장하시겠습니까?") == DialogResult.Cancel) return;

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (Convert.ToString(dt.Rows[i]["CHK"]) == "0") continue;

                    helper.ExecuteNoneQuery("13MM_StockOut_I", CommandType.StoredProcedure
                        , helper.CreateParameter("PLANTCODE", Convert.ToString(dt.Rows[i]["PLANTCODE"]))
                        , helper.CreateParameter("LOTNO",     Convert.ToString(dt.Rows[i]["MATLOTNO"]))
                        , helper.CreateParameter("ITEMCODE",  Convert.ToString(dt.Rows[i]["ITEMCODE"]))
                        , helper.CreateParameter("QTY",       Convert.ToString(dt.Rows[i]["STOCKQTY"]))
                        , helper.CreateParameter("UNITCODE",  Convert.ToString(dt.Rows[i]["UNITCODE"]))
                        , helper.CreateParameter("WORKERID",  LoginInfo.UserID)
                        );
                    if (helper.RSCODE != "S") throw new Exception("생산 출고 등록 중 오류가 발생하였습니다.");
                }

                helper.Commit();

                DoInquire();
                ShowDialog("정상적으로 등록했습니다.");
            }
            catch (Exception ex)
            {
                helper.Rollback();
                MessageBox.Show(ex.ToString());
            }
            finally
            {
                helper.Close();
            }
        }
        #endregion
    }
}
