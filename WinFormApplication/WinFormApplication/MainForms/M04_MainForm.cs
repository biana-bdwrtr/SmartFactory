using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
// Thread 사용하기 위한 라이브러리
using System.Threading;
using Assambly;
using FormList;
// 프로그램을 호출하기 위한 클래스
//using System.Reflection;

namespace MainForms
{
    public partial class M04_MainForm : Form
    {
        // 현재 시각을 표현할 스레드 객체
        private Thread thNowTime;

        public M04_MainForm()
        {
            InitializeComponent();
            M01_Login m01_Login = new M01_Login();
            m01_Login.ShowDialog();

            // 호출했던 로그인 화면의 결과 Tag 값이 성공이 아니면 프로그램 종료.
            if (Convert.ToBoolean(m01_Login.Tag) != true)
            {
                // 프로그램 강제 종료
                Environment.Exit(0);
            }

            toolStripStatusLabelUserName.Text = Commons.sLoginUserName;
        }

        private void M04_MainForm_Load(object sender, EventArgs e)
        {
            // 현재 시각 Thread 시작.
            thNowTime = new Thread(new ThreadStart(GetNowTime));
            if (thNowTime.IsAlive == false) thNowTime.Start();
        }

        // 신규 스레드를 통한 현재 시간 체크
        // Thread: 프로세스 내부에서 생성되는 작업을 하는 주체.
        //         스레드를 생성함으로써 하나의 프로세스 외 여러가지 일을 동시에 수행 가능.
        private void GetNowTime()
        {
            // 5초 뒤에 스레드 종료를 위한 임시 변수.
            //int iThBreak = 0;
            while (true)
            {
                // 1초마다 갱신.
                Thread.Sleep(1000);
                toolStripStatusLabelNowDate.Text = String.Format("{0:yyyy-MM-dd HH:mm:ss}", DateTime.Now);
                //iThBreak++;
                //if (iThBreak == 5) break;
            }
            
            //MessageBox.Show("현재시각 출력 스레드를 종료합니다.");
            
            // 스레드 종료.
            //thNowTime.Abort();
        }


        #region < 프로그램 종료 >
        private void toolStripButtonExit_Click(object sender, EventArgs e)
        {
            // 프로그램 종료 버튼 클릭.
            ApplicationExit();
        }

        private void ApplicationExit()
        {
            // 확인 메시지 표현 후 프로그램 종료.
            if (MessageBox.Show("프로그램을 종료하시겠습니까?", "프로그램 종료", MessageBoxButtons.YesNo) == DialogResult.No) return;
            
            // 구동되고 있는 스레드 종료.
            if (thNowTime.IsAlive) thNowTime.Abort();


            // Application 종료
            Environment.Exit(0);
        }

        private void M04_MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            // 윈도우창 X 버튼 클릭.
            ApplicationExit();
        }

        private void M_Test_DropDownItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {
            // DropDownItem -> 메뉴가 아래로 펼쳐질 때
            // 메뉴 클릭

            #region < M04_MainForm을 MDI 컨테이너로 사용할 경우 >
            // 1. CS 파일을 직접 호출.
            //Form01_MDI_TEST form01 = new Form01_MDI_TEST();
            // MDI 부모 Form 설정
            //form01.MdiParent = this;
            //MDI 화면 활성화
            //form01.Show();

            // 2. 어셈블리 프로그램 파일로 호출.
            // FormList.dll을 호출.
            //MessageBox.Show($"{Application.StartupPath}\\FormList.dll");
            //System.Reflection.Assembly assembly = System.Reflection.Assembly.LoadFrom($"{Application.StartupPath}\\FormList.dll"); // 어셈블리가 설치된 경로\\FormList.dll
            //// 클릭한 메뉴의 CS 타입 확인. 
            //Type typeForm = assembly.GetType($"FormList.{e.ClickedItem.Name}", true); // FormLIst.Form01_MDI_TEST 타입인지 확인하고 맞으면 true 아니면 false
            //// Form 형식으로 전환.
            //Form FormMDI = (Form)Activator.CreateInstance(typeForm);
            //// MDI 부모 Form 설정.
            //FormMDI.MdiParent = this;
            //// FormMDI 활성화
            //FormMDI.Show();
            #endregion


            #region < TabControl을 MDI 컨테이너로 사용할 경우 >
            // FormList.dll 호출
            System.Reflection.Assembly assembly = System.Reflection.Assembly.LoadFrom($"{Application.StartupPath}\\FormList.dll");

            // 클릭한 메뉴의 CS 타임 확인.
            Type typeForm = assembly.GetType($"FormList.{e.ClickedItem.Name}", true);

            // Form 형식으로 전환.
            Form FormMdi = (Form)Activator.CreateInstance(typeForm);

            // 기존에 나타났던 탭이 있을 경우 기존 탭을 활성화한다.
            for (int i = 0; i < MyTabControl.TabPages.Count; i++)
            {
                if (MyTabControl.TabPages[i].Name == Convert.ToString(e.ClickedItem.Name))
                {
                    // 이미 열려있는 탭 페이지의 name과 클릭한 메뉴의 name이 같은 경우
                    // 그 탭 페이지를 활성화 시키고 return;
                    MyTabControl.SelectedTab = MyTabControl.TabPages[i];
                    return;
                }
            }

            // 탭 페이지에 폼을 추가하여 오픈한다.
            MyTabControl.AddFrom(FormMdi);

            toolStripStatusLabelFormName.Text = MyTabControl.SelectedTab.Text;
            #endregion
        }

        private void toolStripButtonClose_Click(object sender, EventArgs e)
        {
            // 페이지 오픈 여부 확인.
            if (MyTabControl.TabPages.Count == 0) return;

            // 현재 활성화된 페이지 닫기.
            MyTabControl.SelectedTab.Dispose();
        }
        #endregion

        #region < 툴바의 기능 상속 >
        private void toolStripButtonSearch_Click(object sender, EventArgs e)
        {
            // 조회 버튼을 눌렀을 때 하위 폼에 조회 기능을 수행하도록 함.
            ChildCommand("SEARCH");
        }

        private void toolStripButtonInsert_Click(object sender, EventArgs e)
        {
            // 추가 버튼을 눌렀을 때 하위 폼에 신규 추가 기능을 수행하도록 함.
            ChildCommand("ADD");
        }

        private void toolStripButtonDelete_Click(object sender, EventArgs e)
        {
            // 삭제 버튼을 눌렀을 때 하위 폼에 삭제 기능을 수행하도록 함.
            ChildCommand("DELETE");
        }

        private void toolStripButtonSave_Click(object sender, EventArgs e)
        {
            // 저장 버튼을 눌렀을 때 하위 폼에 저장 기능을 수행하도록 함.
            ChildCommand("SAVE");
        }

        // 하위 폼에 명령을 전달할 메서드.
        private void ChildCommand(string Command)
        {
            // 하위 폼에 명령 전달 로직.
            if (this.MyTabControl.TabPages.Count == 0) return;
            var Child = MyTabControl.SelectedTab.Controls[0] as Assambly.IChildCommands;
            if (Child is null) return;
            switch (Command)
            {
                case "SEARCH": Child.Inquire(); break;
                case "ADD":    Child.DoNew();   break;
                case "DELETE": Child.Delete();  break;
                case "SAVE":   Child.Save();    break;
            }
        }
        #endregion

        private void MyTabControl_Selected(object sender, TabControlEventArgs e)
        {
            if (MyTabControl.TabPages.Count == 0)
            {
                toolStripStatusLabelFormName.Text = "Form Name";
                return;
            }
            toolStripStatusLabelFormName.Text = MyTabControl.SelectedTab.Text;
        }

        private void MyTabControl_Selecting(object sender, TabControlCancelEventArgs e)
        {

        }

        //private void timer1_Tick(object sender, EventArgs e)
        //{
        //    // 1틱이 발생될 때마다(Interval: 1000 --> 1초) 현재 일시를 레이블에 출력
        //    toolStripStatusLabelNowDate.Text = string.Format("{0:yyyy-MM-dd HH:mm:ss}", DateTime.Now);
        //}
    }
}
