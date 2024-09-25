#define FT232H                // Enable only one of these defines depending on your device type

using System;
using System.Windows.Forms;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using FTD2XX_NET;


namespace I2C_RegSetting
{

    public partial class FormFT232HComm : Form
    {
        const int DEVICE_ID = 0x0A;

        libMPSSE mI2C;

        enum CMD
        {
            IDLE = 0x15,
            ERASE = 0x4B,
            CMD_TRAN = 0x35,
            WRITE_ON = 0x09,
            CHECK_BUSY = 0x64,
            WRITE_OFF = 0x20,
            READ_ALL_ON = 0x40,
            READ_ALL_OFF = 0x50,
            PCI_END = 0x70
        }

        public FormFT232HComm()
        {
            InitializeComponent();
            mConnectDev.Text = String.Format("0x{0:X2}", DEVICE_ID);
            mI2C = new libMPSSE(DEVICE_ID, this);

            mLogText.Text = null;

            UInt32 ftdiDeviceCount = 0;
            FTDI.FT_STATUS ftStatus = FTDI.FT_STATUS.FT_OK;
            FTDI tempFtdiDevice = new FTDI();
            ftStatus = tempFtdiDevice.GetNumberOfDevices(ref ftdiDeviceCount);
            // Check status
            if (ftStatus == FTDI.FT_STATUS.FT_OK)
                PrintLog(String.Format("# of FTDI devices = " + ftdiDeviceCount.ToString()));
            // else
            //    throw new ASCOM.InvalidValueException("Error getting count FTDI devices");

            if (ftdiDeviceCount > 0)
            {
                // Allocate storage for device info list
                FTDI.FT_DEVICE_INFO_NODE[] ftdiDeviceList = new FTDI.FT_DEVICE_INFO_NODE[ftdiDeviceCount];
                // Populate our device list
                ftStatus = tempFtdiDevice.GetDeviceList(ftdiDeviceList);
                //Show device properties
                if (ftStatus == FTDI.FT_STATUS.FT_OK)
                {
                    for (UInt32 i = 0; i < ftdiDeviceCount; i++)
                    {
                        PrintLog(String.Format("Device Index: " + i.ToString()));
                        PrintLog(String.Format("Flags: " + String.Format("{0:x}", ftdiDeviceList[i].Flags)));
                        PrintLog(String.Format("Type: " + ftdiDeviceList[i].Type.ToString()));
                        PrintLog(String.Format("ID: " + String.Format("{0:x}", ftdiDeviceList[i].ID)));
                        PrintLog(String.Format("Location ID: " + String.Format("{0:x}", ftdiDeviceList[i].LocId)));
                        PrintLog(String.Format("Serial Number: " + ftdiDeviceList[i].SerialNumber.ToString()));
                        PrintLog(String.Format("Description: " + ftdiDeviceList[i].Description.ToString()));
                        PrintLog(String.Format(""));

                        comboBox_deviceName.Items.Add(ftdiDeviceList[i].Description.ToString());

                        if (ftdiDeviceList[i].Description.Contains("FT232H"))
                        {
                            comboBox_deviceName.SelectedIndex = (int)i;
                        }
                    }
                }
                // else throw new ASCOM.InvalidValueException("Error getting parameters from FTDI devices");
            }
            //Close device
            ftStatus = tempFtdiDevice.Close();

            this.dev_connect();

            usAddr = 0;
            usData = 0;

            //if(BitConverter.IsLittleEndian)
            //     Console.WriteLine("little endian");
            // else
            //     Console.WriteLine("big endian");

            SetupListView();

            textBox1.Hide();
        }
        private void SetupListView()
        {
            // 리스트뷰 아이템을 업데이트 하기 시작.
            // 업데이트가 끝날 때까지 UI 갱신 중지.
            listView1.BeginUpdate();

            // 뷰모드 지정
            listView1.View = View.Details;
            listView1.GridLines = true;
            listView1.MultiSelect = false;
            listView1.FullRowSelect = true;
            //listView1.CheckBoxes = false;

            // 컬럼명과 컬럼사이즈 지정
            listView1.Columns.Add("Address", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("Value", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("Name", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("Description", 100, HorizontalAlignment.Left);


            for (int i = 0; i < 16; i++)
            {
                String addr = String.Format("0x{0:X4}", i);
                String[] aa = { addr, addr, "-", "" };
                ListViewItem newitem = new ListViewItem(aa);
                listView1.Items.Add(newitem);

                //newitem = new ListViewItem(new String[] { "bb1", "bb2", "bb3", "" });
                //listView1.Items.Add(newitem);
            }
            // 리스뷰를 Refresh하여 보여줌
            listView1.EndUpdate();


            listView2.BeginUpdate();
            listView2.View = View.Details;
            listView2.GridLines = true;
            listView2.MultiSelect = false;
            listView2.FullRowSelect = true;
            //listView2.CheckBoxes = false;
            listView2.Columns.Add("Address", 100, HorizontalAlignment.Left);
            listView2.Columns.Add("Value", 100, HorizontalAlignment.Left);
            listView2.Columns.Add("Name", 100, HorizontalAlignment.Left);
            listView2.Columns.Add("Description", 100, HorizontalAlignment.Left);
            for (int i = 0; i < 16; i++)
            {
                String addr = String.Format("0x{0:X4}", i + 0x0010);
                String[] aa = { addr, addr, "-", "" };
                ListViewItem newitem = new ListViewItem(aa);
                listView2.Items.Add(newitem);
            }
            listView2.EndUpdate();


            listView3.BeginUpdate();
            listView3.View = View.Details;
            listView3.GridLines = true;
            listView3.MultiSelect = false;
            listView3.FullRowSelect = true;
            //listView3.CheckBoxes = false;
            listView3.Columns.Add("Address", 100, HorizontalAlignment.Left);
            listView3.Columns.Add("Value", 100, HorizontalAlignment.Left);
            listView3.Columns.Add("Name", 100, HorizontalAlignment.Left);
            listView3.Columns.Add("Description", 100, HorizontalAlignment.Left);
            for (int i = 0; i < 16; i++)
            {
                String addr = String.Format("0x{0:X4}", i + 0x0800);
                String[] aa = { addr, "0x0000", "-", "" };
                ListViewItem newitem = new ListViewItem(aa);
                listView3.Items.Add(newitem);
            }
            listView3.EndUpdate();

        }
        private void SetupDataGridView()
        {
            this.Controls.Add(dataGridView1);
            dataGridView1.ColumnCount = 128;

            // 전체적으로 폰트 적용하기
            this.dataGridView1.Font = new Font("Tahoma", 10, FontStyle.Regular);
            // Colum 의 해더부분을 지정하기
            this.dataGridView1.ColumnHeadersDefaultCellStyle.Font = new Font("Tahoma", 6, FontStyle.Bold);
            // Row 해더부분을 지정하기
            this.dataGridView1.RowHeadersDefaultCellStyle.Font = new Font("Tahoma", 6, FontStyle.Bold);
            // Cell 내용부분을 지정하기
            this.dataGridView1.DefaultCellStyle.Font = new Font("Tahoma", 10, FontStyle.Bold);
            this.dataGridView1.DefaultCellStyle.BackColor = Color.FromArgb(255, 255, 255, 255);

            for (int col = 0; col < 128; col++)
            {
                dataGridView1.Columns[col].Name = String.Format("{0:d}", col);
                dataGridView1.Columns[col].Width = 20;

            }

            for (int row = 0; row < 90; row++)
            {
                dataGridView1.Rows.Add();
                dataGridView1.Rows[row].HeaderCell.Value = String.Format("{0:d}", row);
            }


            for (int row = 0; row < dataGridView1.Rows.Count; row++)//y
            {
                for (int col = 0; col < dataGridView1.ColumnCount; col++)//x
                {
                    Color backColor = Color.FromArgb(255, 0, 0, 0);

                    if (row == 0) backColor = Color.FromArgb(255, 255, 255, 255);
                    if (row == 44) backColor = Color.FromArgb(255, 255, 255, 255);
                    if (row == 45) backColor = Color.FromArgb(255, 255, 255, 255);
                    if (row == 89) backColor = Color.FromArgb(255, 255, 255, 255);

                    if (col == 0) backColor = Color.FromArgb(255, 255, 255, 255);
                    if (col == 63) backColor = Color.FromArgb(255, 255, 255, 255);
                    if (col == 64) backColor = Color.FromArgb(255, 255, 255, 255);
                    if (col == 127) backColor = Color.FromArgb(255, 255, 255, 255);

                    dataGridView1.Rows[row].Cells[col].Style.BackColor = backColor;
                }
            }

        }
        private void dev_connect()
        {
            String message;
            int devid;

            if (mConnectDev.Text.Contains("0x"))
            {
                devid = Convert.ToInt32(mConnectDev.Text, 16);
            }
            else
            {
                devid = Convert.ToInt32(mConnectDev.Text);
            }

            if (mI2C.Connect(devid, (uint)comboBox_deviceName.SelectedIndex))
            {
                mConnectInfo.Text = "Connected!!";

                message = String.Format("Connected! - {0}", mI2C.GetInfo());
                PrintLog(message + ", 0x{0:X02}", devid);
                //mConnectDev.ReadOnly = true;

            }
            else
            {
                mConnectInfo.Text = "Failed to connect";
                message = String.Format("Failed to connect - 0x{0:X2}", DEVICE_ID);
                PrintLog(message);

            }
        }
        public void PrintLog(String value, params Object[] args)
        {

            DateTime now = DateTime.Now;

            String time = now.ToString("HH:mm:ss.fff") + "\t";
            String function = String.Format("[{0}] ", new StackFrame(1, true).GetMethod().Name);
            String msg = String.Format(time + function + value + "\r\n", args);
            mLogText.AppendText(msg);

            //mLogText.ScrollToLine(mLogText.LineCount - 1);

        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.dev_connect();
        }
        private void button2_Click(object sender, EventArgs e)
        {
            String message;
            if (!mI2C.IsOpened())
            {
                message = "Already disconnected!";
                PrintLog(message);
            }
            else
            {
                if (mI2C.Disconnect())
                {
                    message = "Disconnected!";
                    PrintLog(message);
                    mConnectInfo.Text = message;
                    //mConnectDev.ReadOnly = false;
                }
                else
                {
                    message = "Failed to disconnect!";
                    PrintLog(message);
                    mConnectInfo.Text = message;
                }
            }
        }

        public void setDataGridView1_CellBackColor(int RowIndex, int ColumnIndex, Color backColor)
        {
            this.dataGridView1.Rows[RowIndex].Cells[ColumnIndex].Style.BackColor = backColor;
        }
        private void dataGridView1_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            DataGridViewCell cell = this.dataGridView1.Rows[e.RowIndex].Cells[e.ColumnIndex];
            cell.ToolTipText = String.Format("{0:d},{1:d}", e.ColumnIndex, e.RowIndex);
            cell.ToolTipText += String.Format("\r\n RGB {0:d}:{1:d}:{2:d}", cell.Style.BackColor.R, cell.Style.BackColor.G, cell.Style.BackColor.B);
        }
        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            Point cellpos = new Point(e.RowIndex, e.ColumnIndex);
            foreach (Form openForm in Application.OpenForms)
            {
                if (openForm.Name == "CellEditdlg") //폼 중복 열기 방지
                {
                    if (openForm.WindowState == FormWindowState.Minimized)
                    {
                        openForm.WindowState = FormWindowState.Normal;
                    }
                    openForm.Activate();
                    return;
                }
            }

            FormCellEdit CellEditdlg = new FormCellEdit(this, cellpos);

            CellEditdlg.StartPosition = FormStartPosition.Manual;
            CellEditdlg.Location = new Point(Cursor.Position.X, Cursor.Position.Y);

            CellEditdlg.Show();

        }
        private void button_dump_Click(object sender, EventArgs e)
        {


            //프로그램 실행시 Data 폴더 확인 및 없을경우 Data 폴더 생성
            System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(Application.StartupPath + @"\Data");
            if (!di.Exists) { di.Create(); }
            PrintLog(di.FullName);

            //a b
            //c d

            List<ushort> ra_bytes_list = new List<ushort>();
            List<ushort> ga_bytes_list = new List<ushort>();
            List<ushort> ba_bytes_list = new List<ushort>();

            List<ushort> rb_bytes_list = new List<ushort>();
            List<ushort> gb_bytes_list = new List<ushort>();
            List<ushort> bb_bytes_list = new List<ushort>();

            List<ushort> rc_bytes_list = new List<ushort>();
            List<ushort> gc_bytes_list = new List<ushort>();
            List<ushort> bc_bytes_list = new List<ushort>();

            List<ushort> rd_bytes_list = new List<ushort>();
            List<ushort> gd_bytes_list = new List<ushort>();
            List<ushort> bd_bytes_list = new List<ushort>();


            for (int row = 0; row < dataGridView1.Rows.Count; row++)//y
            {
                for (int col = 0; col < dataGridView1.ColumnCount; col++)//x
                {
                    Color backColor = dataGridView1.Rows[row].Cells[col].Style.BackColor;

                    if ((row < dataGridView1.Rows.Count / 2) && (col < dataGridView1.ColumnCount / 2))//a
                    {
                        ra_bytes_list.Add((ushort)Math.Pow((double)backColor.R, 2));
                        ga_bytes_list.Add((ushort)Math.Pow((double)backColor.G, 2));
                        ba_bytes_list.Add((ushort)Math.Pow((double)backColor.B, 2));
                    }
                    else if ((row < dataGridView1.Rows.Count / 2) && (dataGridView1.ColumnCount / 2 <= col))//b
                    {
                        rb_bytes_list.Add((ushort)Math.Pow((double)backColor.R, 2));
                        gb_bytes_list.Add((ushort)Math.Pow((double)backColor.G, 2));
                        bb_bytes_list.Add((ushort)Math.Pow((double)backColor.B, 2));
                    }
                    else if ((dataGridView1.Rows.Count / 2 <= row) && (col < dataGridView1.ColumnCount / 2))//c
                    {
                        rc_bytes_list.Add((ushort)Math.Pow((double)backColor.R, 2));
                        gc_bytes_list.Add((ushort)Math.Pow((double)backColor.G, 2));
                        bc_bytes_list.Add((ushort)Math.Pow((double)backColor.B, 2));
                    }
                    else//d
                    {
                        rd_bytes_list.Add((ushort)Math.Pow((double)backColor.R, 2));
                        gd_bytes_list.Add((ushort)Math.Pow((double)backColor.G, 2));
                        bd_bytes_list.Add((ushort)Math.Pow((double)backColor.B, 2));
                    }

                    //string message = String.Format(" {0:d} {1:d}", row, col);
                    //PrintLog(message);
                }
            }

            for (int list = 0; list < 4096; list++)
            {
                if (4096 <= bd_bytes_list.Count) break;
                ra_bytes_list.Add(0); ga_bytes_list.Add(0); ba_bytes_list.Add(0);
                rb_bytes_list.Add(0); gb_bytes_list.Add(0); bb_bytes_list.Add(0);
                rc_bytes_list.Add(0); gc_bytes_list.Add(0); bc_bytes_list.Add(0);
                rd_bytes_list.Add(0); gd_bytes_list.Add(0); bd_bytes_list.Add(0);
            }

            ushort[] ra_bytes = ra_bytes_list.ToArray();
            ushort[] ga_bytes = ga_bytes_list.ToArray();
            ushort[] ba_bytes = ba_bytes_list.ToArray();

            ushort[] rb_bytes = rb_bytes_list.ToArray();
            ushort[] gb_bytes = gb_bytes_list.ToArray();
            ushort[] bb_bytes = bb_bytes_list.ToArray();

            ushort[] rc_bytes = rc_bytes_list.ToArray();
            ushort[] gc_bytes = gc_bytes_list.ToArray();
            ushort[] bc_bytes = bc_bytes_list.ToArray();

            ushort[] rd_bytes = rd_bytes_list.ToArray();
            ushort[] gd_bytes = gd_bytes_list.ToArray();
            ushort[] bd_bytes = bd_bytes_list.ToArray();

            // 이진파일 생성
            FileStream afs = File.Open(di.FullName + "\\a_data.bin", FileMode.Create);
            using (BinaryWriter wr = new BinaryWriter(afs))
            {
                foreach (ushort us in ra_bytes) { wr.Write(us); }
                foreach (ushort us in ga_bytes) { wr.Write(us); }
                foreach (ushort us in ba_bytes) { wr.Write(us); }
            }

            FileStream bfs = File.Open(di.FullName + "\\b_data.bin", FileMode.Create);
            using (BinaryWriter wr = new BinaryWriter(bfs))
            {
                foreach (ushort us in ra_bytes) { wr.Write(us); }
                foreach (ushort us in ga_bytes) { wr.Write(us); }
                foreach (ushort us in ba_bytes) { wr.Write(us); }
            }

            FileStream cfs = File.Open(di.FullName + "\\c_data.bin", FileMode.Create);
            using (BinaryWriter wr = new BinaryWriter(cfs))
            {
                foreach (ushort us in ra_bytes) { wr.Write(us); }
                foreach (ushort us in ga_bytes) { wr.Write(us); }
                foreach (ushort us in ba_bytes) { wr.Write(us); }
            }

            FileStream dfs = File.Open(di.FullName + "\\d_data.bin", FileMode.Create);
            using (BinaryWriter wr = new BinaryWriter(dfs))
            {
                foreach (ushort us in ra_bytes) { wr.Write(us); }
                foreach (ushort us in ga_bytes) { wr.Write(us); }
                foreach (ushort us in ba_bytes) { wr.Write(us); }
            }


        }

        ushort usAddr = 0;
        ushort usData = 0;
        private void getTbAddrData()
        {
            try
            {
                if (tabControl1.SelectedIndex == 0)
                {
                    if (tB_tab1_addr.Text.Contains("0x"))
                        usAddr = Convert.ToUInt16(tB_tab1_addr.Text, 16);
                    else
                        usAddr = Convert.ToUInt16(tB_tab1_addr.Text, 10);

                    if (tB_tab1_data.Text.Contains("0x"))
                        usData = Convert.ToUInt16(tB_tab1_data.Text, 16);
                    else
                        usData = Convert.ToUInt16(tB_tab1_data.Text, 10);

                }
                else if (tabControl1.SelectedIndex == 1)
                {
                    if (tB_tab2_addr.Text.Contains("0x"))
                        usAddr = Convert.ToUInt16(tB_tab2_addr.Text, 16);
                    else
                        usAddr = Convert.ToUInt16(tB_tab2_addr.Text, 10);

                    if (tB_tab2_data.Text.Contains("0x"))
                        usData = Convert.ToUInt16(tB_tab2_data.Text, 16);
                    else
                        usData = Convert.ToUInt16(tB_tab2_data.Text, 10);
                }
                else
                {
                    if (tB_tab3_addr.Text.Contains("0x"))
                        usAddr = Convert.ToUInt16(tB_tab3_addr.Text, 16);
                    else
                        usAddr = Convert.ToUInt16(tB_tab3_addr.Text, 10);

                    if (tB_tab3_data.Text.Contains("0x"))
                        usData = Convert.ToUInt16(tB_tab3_data.Text, 16);
                    else
                        usData = Convert.ToUInt16(tB_tab3_data.Text, 10);
                }
            }
            catch
            {
                return;
            }
        }
        private void textBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                //write_16bit_reg(ref us0x9D9C);
            }
            else
            {
                return;
            }
        }

        private void btnTab1WriteTest_Click(object sender, EventArgs e)
        {
            ushort inc = 0x0001;
            ushort wr = 0x0000;

            getTbAddrData();
            ushort cmd = (ushort)(((uint)usAddr << 2) | ((uint)inc << 1) | (uint)wr);
            //byte[] cmd_bytes = BitConverter.GetBytes(cmd);
            //Array.Reverse(cmd_bytes);
            //cmd = BitConverter.ToUInt16(cmd_bytes, 0);

            //usData = Convert.ToUInt16(tB_tab1_data.Text, 16);
            //byte[] usData_bytes = BitConverter.GetBytes(usData);
            //Array.Reverse(usData_bytes);
            //usData = BitConverter.ToUInt16(usData_bytes, 0);

            ushort[] srcdate = { cmd, usData };
            mI2C.SPI_DataTransmit(srcdate);
        }
        private void btnTab1ReadTest_Click(object sender, EventArgs e)
        {
            ushort inc = 0x0001;
            ushort rd = 0x0001;

            getTbAddrData();
            ushort[] rdata = new ushort[50];

            ushort cmd = (ushort)(((uint)usAddr << 2) | ((uint)inc << 1) | (uint)rd);

            rdata[0] = cmd;
            ushort[] cmd_arr = { cmd };
            mI2C.SPI_DataTransmit(cmd_arr, ref rdata, 1);
        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl1.SelectedIndex == 1)
            {
            }
            else if (tabControl1.SelectedIndex == 2)
            {
                this.SetupDataGridView();
                PrintLog("test");
            }

        }

        private void btnTab1MultiWrite_Click(object sender, EventArgs e)
        {
            ushort inc = 0x0001;
            ushort wr = 0x0000;

            string cmd_str = listView1.Items[0].SubItems[0].Text;
            ushort start_addr = Convert.ToUInt16(cmd_str, 16);
            ushort cmd = (ushort)(((uint)start_addr << 2) | ((uint)inc << 1) | (uint)wr);

            ushort[] cmd_arr = { cmd };
            ushort[] data_arr = new ushort[16];

            for (int i = 0; i < 16; i++)
            {
                string tmp = listView1.Items[i].SubItems[1].Text;
                data_arr[i] = Convert.ToUInt16(tmp, 16);
            }

            List<ushort> list = new List<ushort>();
            list.AddRange(cmd_arr);
            list.AddRange(data_arr);

            ushort[] srcdata = list.ToArray();

            mI2C.SPI_DataTransmit(srcdata);
        }

        private void btnTab1MultiRead_Click(object sender, EventArgs e)
        {
            ushort inc = 0x0001;
            ushort rd = 0x0001;

            ushort[] rdata = new ushort[50];

            string cmd_str = listView1.Items[0].SubItems[0].Text;
            ushort start_addr = Convert.ToUInt16(cmd_str, 16);
            ushort cmd = (ushort)(((uint)start_addr << 2) | ((uint)inc << 1) | (uint)rd);

            rdata[0] = cmd;
            ushort[] cmd_arr = { cmd };

            mI2C.SPI_DataTransmit(cmd_arr, ref rdata, 16);
            for (int i = 0; i < 16; i++)
            {
                listView1.Items[i].SubItems[1].Text = string.Format("0x{0:X4}", rdata[i]);
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {

            // int SelectRow = listView1.SelectedItems[0].Index;             
            //string a = listView1.Items[1].SubItems[0].Text;
            //string b = listView1.Items[1].SubItems[1].Text;

            //Console.WriteLine(a);
            //Console.WriteLine(b);

            listView1.Items[1].SubItems[1].Text = "asdfg";
        }

        private void btnTab2WriteTest_Click(object sender, EventArgs e)
        {
            getTbAddrData();
            ushort cmd = (ushort)(((uint)usAddr << 2) | ((uint)0x0001 << 1) | (uint)0x0000);
            ushort[] srcdate = { cmd, usData };
            mI2C.SPI_DataTransmit(srcdate);
        }

        private void btnTab2ReadTest_Click(object sender, EventArgs e)
        {
            getTbAddrData();
            ushort[] rdata = new ushort[50];
            ushort cmd = (ushort)(((uint)usAddr << 2) | ((uint)0x0001 << 1) | (uint)0x0001);
            ushort[] cmd_arr = { cmd };
            mI2C.SPI_DataTransmit(cmd_arr, ref rdata, 1);
        }

        private void btnTab2MultiWrite_Click(object sender, EventArgs e)
        {
            ushort inc = 0x0001;
            ushort wr = 0x0000;

            string cmd_str = listView2.Items[0].SubItems[0].Text;
            ushort start_addr = Convert.ToUInt16(cmd_str, 16);
            ushort cmd = (ushort)(((uint)start_addr << 2) | ((uint)inc << 1) | (uint)wr);

            ushort[] cmd_arr = { cmd };
            ushort[] data_arr = new ushort[16];

            for (int i = 0; i < 16; i++)
            {
                string tmp = listView1.Items[i].SubItems[1].Text;
                data_arr[i] = Convert.ToUInt16(tmp, 16);
            }

            List<ushort> list = new List<ushort>();
            list.AddRange(cmd_arr);
            list.AddRange(data_arr);

            ushort[] srcdata = list.ToArray();

            mI2C.SPI_DataTransmit(srcdata);
        }

        private void btnTab2MultiRead_Click(object sender, EventArgs e)
        {
            ushort inc = 0x0001;
            ushort rd = 0x0001;

            ushort[] rdata = new ushort[50];

            string cmd_str = listView2.Items[0].SubItems[0].Text;
            ushort start_addr = Convert.ToUInt16(cmd_str, 16);
            ushort cmd = (ushort)(((uint)start_addr << 2) | ((uint)inc << 1) | (uint)rd);

            ushort[] cmd_arr = { cmd };

            mI2C.SPI_DataTransmit(cmd_arr, ref rdata, 16);
            for (int i = 0; i < 16; i++)
            {
                listView1.Items[i].SubItems[1].Text = string.Format("0x{0:X4}", rdata[i]);
            }
        }

        ListViewItem curItem;
        ListViewItem.ListViewSubItem curSB;
        private void ListView1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            curItem = listView1.GetItemAt(e.X, e.Y);
            if (curItem == null) return;

            curSB = curItem.GetSubItemAt(e.X, e.Y);
            int idxSub = curItem.SubItems.IndexOf(curSB);

            switch (idxSub)
            {
                case 1: break;

                default: return;
            }

            int ILeft = curSB.Bounds.Left + 7;
            int IWidth = curSB.Bounds.Width;

            textBox1.SetBounds(ILeft + listView1.Left, curSB.Bounds.Bottom + 5 + listView1.Top, IWidth, curSB.Bounds.Height);
            textBox1.Text = curSB.Text;
            textBox1.Show();
            textBox1.Focus();
        }
        private void ListView2_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            curItem = listView2.GetItemAt(e.X, e.Y);
            if (curItem == null) return;

            curSB = curItem.GetSubItemAt(e.X, e.Y);
            int idxSub = curItem.SubItems.IndexOf(curSB);

            switch (idxSub)
            {
                case 1: break;

                default: return;
            }

            int ILeft = curSB.Bounds.Left + 2;
            int IWidth = curSB.Bounds.Width;

            textBox1.SetBounds(ILeft + listView2.Left, curSB.Bounds.Bottom + 5 + listView2.Top, IWidth, curSB.Bounds.Height);
            textBox1.Text = curSB.Text;
            textBox1.Show();
            textBox1.Focus();
        }
        bool cancelEdit;
        private void TextBox1_KeyDown(object sender, KeyEventArgs e)
        {
            //엔터키:수정 ESC키:취소
            switch(e.KeyCode)
            {
                case System.Windows.Forms.Keys.Enter:
                    cancelEdit = false;
                    e.Handled = true;
                    textBox1.Hide();
                    break;
                case System.Windows.Forms.Keys.Escape:
                    cancelEdit = true;
                    e.Handled = true;
                    textBox1.Hide();
                    break;
            }
        }
        private void textBox1_Leave(object sender, EventArgs e)
        {
            textBox1.Hide();
            if(cancelEdit ==false)
            {
                if(textBox1.Text.Trim() != "")
                {
                    try
                    {
                        ushort value = 0;
                        if (textBox1.Text.Contains("0x"))
                            value = Convert.ToUInt16(textBox1.Text, 16);
                        else
                            value = Convert.ToUInt16(textBox1.Text, 10);

                        //string hex = "0x"+ value.ToString("X");
                        string hex = string.Format("0x{0:X4}", value);

                        curSB.Text = hex;
                        int idxSub = curItem.SubItems.IndexOf(curSB);
                        int idx = curItem.Index;

                        Console.Write(curSB.Text); //someting to do

                    }
                    catch
                    {
                        //Console.WriteLine("numString is not a valid");
                        PrintLog("numString is not a valid");
                    }

                    //UInt16 number2 = 0;
                    //string numString = textBox1.Text;
                    //bool canConvert = UInt16.TryParse(numString, out number2);
                    //if (canConvert == true)
                    //    Console.WriteLine("number2 now = {0}", number2);
                    //else
                    //    Console.WriteLine("numString is not a valid byte");

                }

            }
            else
            {
                cancelEdit = false;
            }
            listView1.Focus();
        }




        class libMPSSE
        {
            //###################################################################################################################################
            //###################################################################################################################################
            //################                                        Definitions                                             ###################
            //###################################################################################################################################
            //###################################################################################################################################

            private int mSlave = 0x00;
            private FormFT232HComm mMainWindow;

            // ###### Driver defines ######
            FTDI.FT_STATUS ftStatus = FTDI.FT_STATUS.FT_OK;
            // MPSSE clocking commands
            const byte MSB_FALLING_EDGE_CLOCK_BYTE_IN = 0x24;
            const byte MSB_RISING_EDGE_CLOCK_BYTE_IN = 0x20;
            const byte MSB_FALLING_EDGE_CLOCK_BYTE_OUT = 0x11;
            const byte MSB_DOWN_EDGE_CLOCK_BIT_IN = 0x26;
            const byte MSB_UP_EDGE_CLOCK_BYTE_IN = 0x20;
            const byte MSB_UP_EDGE_CLOCK_BYTE_OUT = 0x10;
            const byte MSB_RISING_EDGE_CLOCK_BIT_IN = 0x22;
            const byte MSB_FALLING_EDGE_CLOCK_BIT_OUT = 0x13;

            // Sending and receiving
            static uint NumBytesToSend = 0;
            static uint NumBytesToRead = 0;
            uint NumBytesSent = 0;
            static uint NumBytesRead = 0;
            static byte[] MPSSEbuffer = new byte[4096];
            static byte[] InputBuffer = new byte[4096];
            static byte[] InputBuffer2 = new byte[4096];
            static uint BytesAvailable = 0;

            static byte AppStatus = 0;
            static byte MPSSE_Status = 0;
            //private bool Running = true;
            private bool DeviceOpen = false;
            // GPIO
            static byte GPIO_Low_Dat = 0;
            static byte GPIO_Low_Dir = 0;


            uint devcount = 0;



            //###################################################################################################################################
            //###################################################################################################################################
            //##################                          Main Application Layer                                            #####################
            //###################################################################################################################################
            //###################################################################################################################################

            // Create new instance of the FTDI device class
            FTDI myFtdiDevice = new FTDI();

            public libMPSSE(int slave, FormFT232HComm mainForm)
            {
                mSlave = slave;
                mMainWindow = mainForm;

            }
            public libMPSSE(FormFT232HComm mainForm)
            {
                mMainWindow = mainForm;
            }

            public bool Connect(int devid, uint dev_index)
            {
                String log;

                try
                {
                    ftStatus = myFtdiDevice.GetNumberOfDevices(ref devcount);

                }
                catch
                {
                    DeviceOpen = false;
                    return DeviceOpen;
                }

                log = String.Format("devcount : {0}", devcount);
                mMainWindow.PrintLog(log);

                // e.g. open a UM232H Module by it's description
                //ftStatus = myFtdiDevice.OpenByDescription("UM232H");  // could replace line below
                ftStatus = myFtdiDevice.OpenByIndex(dev_index);

                // Update the Status text line
                if (ftStatus == FTDI.FT_STATUS.FT_OK)
                {
                    AppStatus = SPI_ConfigureMpsse();
                    if (AppStatus != 0)
                    {
                        DeviceOpen = false;
                        myFtdiDevice.Close();
                    }
                    DeviceOpen = true;

                    mMainWindow.PrintLog("Device is opened!");

                }
                else
                {
                    mMainWindow.PrintLog("Device open failed!");
                    DeviceOpen = false;
                }


                return DeviceOpen;
            }
            public bool Disconnect()
            {
                bool ret = true;

                if (IsOpened())
                {
                    // Make sure the white LED of the colour sensor is off (ADbus3 is high)
                    GPIO_Low_Dat = 0x08;
                    GPIO_Low_Dir = 0x08;

                    // Close the FTDI device and then close the window
                    myFtdiDevice.Close();
                    DeviceOpen = false;
                }
                else
                {
                    ret = false;
                }

                return ret;
            }
            public bool IsOpened()
            {
                return DeviceOpen;
            }
            public int GetStatus()
            {
                return (int)ftStatus;
            }
            public String GetInfo()
            {
                String SerialNumber;
                String Description;

                if (!IsOpened())
                {
                    mMainWindow.PrintLog("Device is not opened!");
                    return null;
                }
                myFtdiDevice.GetSerialNumber(out SerialNumber);
                myFtdiDevice.GetDescription(out Description);

                return Description + " " + SerialNumber;
            }
            public String GetName()
            {
                String name;

                if (!IsOpened())
                {
                    return null;
                }

                myFtdiDevice.GetDescription(out name);

                return name;
            }

            public int GetdevID()
            {
                return mSlave;
            }
            public void SetdevID(int slave)
            {
                mSlave = slave;
            }
            public byte Getbyte()
            {
                return InputBuffer2[0];
            }

            #region SPI Layer

            public byte SPI_ConfigureMpsse()
            {
                NumBytesToSend = 0;

                /***** Initial device configuration *****/

                ftStatus = FTDI.FT_STATUS.FT_OK;
                ftStatus |= myFtdiDevice.SetTimeouts(5000, 5000);
                ftStatus |= myFtdiDevice.SetLatency(16);
                ftStatus |= myFtdiDevice.SetFlowControl(FTDI.FT_FLOW_CONTROL.FT_FLOW_NONE, 0x00, 0x00);
                ftStatus |= myFtdiDevice.SetBitMode(0x00, 0x00);
                ftStatus |= myFtdiDevice.SetBitMode(0xff, 0x02);         // MPSSE mode        

                if (ftStatus != FTDI.FT_STATUS.FT_OK)
                    return 1; // error();

                /***** Flush the buffer *****/
                MPSSE_Status = FlushBuffer();

                /***** Synchronize the MPSSE interface by sending bad command 0xAA *****/
                NumBytesToSend = 0;
                MPSSEbuffer[NumBytesToSend++] = 0xAA;
                MPSSE_Status = Send_Data(NumBytesToSend);
                if (MPSSE_Status != 0) return 1; // error();
                NumBytesToRead = 2;
                MPSSE_Status = Receive_Data(2);
                if (MPSSE_Status != 0) return 1; //error();

                if ((InputBuffer2[0] == 0xFA) && (InputBuffer2[1] == 0xAA))
                {
                    Console.WriteLine("Bad Command Echo successful");
                }
                else
                {
                    return 1;            //error();
                }

                /***** Synchronize the MPSSE interface by sending bad command 0xAB *****/
                NumBytesToSend = 0;
                MPSSEbuffer[NumBytesToSend++] = 0xAB;
                MPSSE_Status = Send_Data(NumBytesToSend);
                if (MPSSE_Status != 0) return 1; // error();
                NumBytesToRead = 2;
                MPSSE_Status = Receive_Data(2);
                if (MPSSE_Status != 0) return 1; //error();

                if ((InputBuffer2[0] == 0xFA) && (InputBuffer2[1] == 0xAB))
                {
                    Console.WriteLine("Bad Command Echo successful");
                }
                else
                {
                    return 1;            //error();
                }

                NumBytesToSend = 0;
                MPSSEbuffer[NumBytesToSend++] = 0x8A; 	// Disable clock divide by 5 for 60Mhz master clock
                //MPSSEbuffer[NumBytesToSend++] = 0x97;	// Turn off adaptive clocking
                //MPSSEbuffer[NumBytesToSend++] = 0x8C; 	// Enable 3 phase data clock, used by I2C to allow data on both clock edges
                MPSSEbuffer[NumBytesToSend++] = 0x8D; 	// Disable 3 phase data clock,

                // The SK clock frequency can be worked out by below algorithm with divide by 5 set as off
                // SK frequency  = 60MHz /((1 +  [(1 +0xValueH*256) OR 0xValueL])*2)
                MPSSEbuffer[NumBytesToSend++] = 0x86;
                MPSSEbuffer[NumBytesToSend++] = 0x10;
                MPSSEbuffer[NumBytesToSend++] = 0x00;


                MPSSEbuffer[NumBytesToSend++] = 0x85; 			// loopback off

                MPSSEbuffer[NumBytesToSend++] = 0x9E;       //Enable the FT232H's drive-zero mode with the following enable mask...
                MPSSEbuffer[NumBytesToSend++] = 0x07;       // ... Low byte (ADx) enables - bits 0, 1 and 2 and ... 
                MPSSEbuffer[NumBytesToSend++] = 0x00;       //...High byte (ACx) enables - all off

                GPIO_Low_Dat = 0x08;
                GPIO_Low_Dir = 0xFB;

                MPSSEbuffer[NumBytesToSend++] = 0x80; 	//Command to set directions of lower 8 pins and force value on bits set as output 
                MPSSEbuffer[NumBytesToSend++] = (byte)(GPIO_Low_Dat);
                MPSSEbuffer[NumBytesToSend++] = (byte)(GPIO_Low_Dir);

                MPSSE_Status = Send_Data(NumBytesToSend);
                if (MPSSE_Status != 0)
                {
                    return 1;            //error();
                }
                else
                {
                    return 0;
                }
            }

            public void SPI_DataTransmit(ushort[] data)
            {
                NumBytesToSend = 0;

                Clear_NCS();

                MPSSEbuffer[NumBytesToSend++] = 0x11;
                int datlen = (data.Length * 2) - 1;
                MPSSEbuffer[NumBytesToSend++] = (byte)(datlen & 0x00FF);
                MPSSEbuffer[NumBytesToSend++] = (byte)((datlen >> 8) & 0x00FF);

                for (int i = 0; i < data.Length; i++)
                {
                    byte[] bytes = BitConverter.GetBytes(data[i]);
                    Array.Reverse(bytes);
                    data[i] = BitConverter.ToUInt16(bytes, 0);
                }

                byte[] byteArray = data.SelectMany(BitConverter.GetBytes).ToArray();
                Buffer.BlockCopy(byteArray, 0, MPSSEbuffer, (int)NumBytesToSend, byteArray.Length);
                NumBytesToSend += (uint)byteArray.Length;

                Set_NCS();

                MPSSE_Status = Send_Data(NumBytesToSend);
            }
            public void SPI_DataTransmit(ushort[] data, ref ushort[] rddata, uint len)
            {
                NumBytesToSend = 0;

                Clear_NCS();

                MPSSEbuffer[NumBytesToSend++] = 0x11;
                int datlen = (data.Length * 2) - 1;
                MPSSEbuffer[NumBytesToSend++] = (byte)(datlen & 0x00FF);
                MPSSEbuffer[NumBytesToSend++] = (byte)((datlen >> 8) & 0x00FF);

                for (int i = 0; i < data.Length; i++)
                {
                    byte[] bytes = BitConverter.GetBytes(data[i]);
                    Array.Reverse(bytes);
                    data[i] = BitConverter.ToUInt16(bytes, 0);
                }

                byte[] byteArray = data.SelectMany(BitConverter.GetBytes).ToArray();
                Buffer.BlockCopy(byteArray, 0, MPSSEbuffer, (int)NumBytesToSend, byteArray.Length);
                NumBytesToSend += (uint)byteArray.Length;

                //Set_NCS();

                MPSSE_Status = Send_Data(NumBytesToSend);
                //---------------------------------------------------------

                NumBytesToSend = 0;

                MPSSEbuffer[NumBytesToSend++] = 0x31;
                uint datlen2 = (len * 2) - 1;
                MPSSEbuffer[NumBytesToSend++] = (byte)(datlen2 & 0x00FF);
                MPSSEbuffer[NumBytesToSend++] = (byte)((datlen2 >> 8) & 0x00FF);

                byte[] byteArray2 = new byte[len * 2];
                for (int i = 0; i < byteArray2.Length; i++)
                    Buffer.SetByte(byteArray2, i, 0xff);

                Buffer.BlockCopy(byteArray2, 0, MPSSEbuffer, (int)NumBytesToSend, byteArray2.Length);
                NumBytesToSend += (uint)byteArray2.Length;

                Set_NCS();

                MPSSE_Status = Send_Data(NumBytesToSend);

                Receive_Data((uint)byteArray2.Length);

                for (int n = 0; n < byteArray2.Length; n += 2)
                {
                    byte[] tmp = new byte[2];
                    tmp[0] = InputBuffer2[n + 1];
                    tmp[1] = InputBuffer2[n];
                    rddata[n / 2] = BitConverter.ToUInt16(tmp, 0);
                }

                String log = String.Format("read data : ");
                for (int i = 0; i < len; i++)
                {
                    log += String.Format("{0:X4}", rddata[i]);
                }

                mMainWindow.PrintLog(log);

            }
            private void Set_NCS()
            {
                //   NumBytesToSend = 0;

                MPSSEbuffer[NumBytesToSend++] = 0x80;
                MPSSEbuffer[NumBytesToSend++] = 0x08;
                MPSSEbuffer[NumBytesToSend++] = 0xFB;

                //  MPSSE_Status = Send_Data(NumBytesToSend);

            }
            private void Clear_NCS()
            {
                // NumBytesToSend = 0;

                MPSSEbuffer[NumBytesToSend++] = 0x80;
                MPSSEbuffer[NumBytesToSend++] = 0x00;
                MPSSEbuffer[NumBytesToSend++] = 0xFB;

                // MPSSE_Status = Send_Data(NumBytesToSend);

            }
            #endregion


            #region D2xx Layer
            //###################################################################################################################################
            //###################################################################################################################################
            //##################                                          D2xx Layer                                        #####################
            //###################################################################################################################################
            //###################################################################################################################################
            //###################################################################################################################################

            private void send_byte(byte data)
            {
                MPSSEbuffer[0] = data;
                Send_Data(1);
            }

            private byte recv_byte()
            {
                Receive_Data(1);
                return InputBuffer2[0];
            }

            // Write a buffer of data and check that it got sent without error

            private byte Send_Data(uint BytesToSend)
            {

                NumBytesToSend = BytesToSend;

                // Send data. This will return once all sent or if times out
                ftStatus = myFtdiDevice.Write(MPSSEbuffer, NumBytesToSend, ref NumBytesSent);

                // Ensure that call completed OK and that all bytes sent as requested
                if ((NumBytesSent != NumBytesToSend) || (ftStatus != FTDI.FT_STATUS.FT_OK))
                    return 1;   // error   calling function can check NumBytesSent to see how many got sent
                else
                    return 0;   // success
            }

            // Read a specified number of bytes from the driver receive buffer
            private byte Receive_Data(uint BytesToRead)
            {
                uint NumBytesInQueue = 0;
                uint QueueTimeOut = 0;
                uint Buffer1Index = 0;
                uint Buffer2Index = 0;
                uint TotalBytesRead = 0;
                bool QueueTimeoutFlag = false;
                uint NumBytesRxd = 0;

                // Keep looping until all requested bytes are received or we've tried 5000 times (value can be chosen as required)
                while ((TotalBytesRead < BytesToRead) && (QueueTimeoutFlag == false))
                {
                    ftStatus = myFtdiDevice.GetRxBytesAvailable(ref NumBytesInQueue);       // Check bytes available

                    if ((NumBytesInQueue > 0) && (ftStatus == FTDI.FT_STATUS.FT_OK))
                    {
                        ftStatus = myFtdiDevice.Read(InputBuffer, NumBytesInQueue, ref NumBytesRxd);  // if any available read them

                        if ((NumBytesInQueue == NumBytesRxd) && (ftStatus == FTDI.FT_STATUS.FT_OK))
                        {
                            Buffer1Index = 0;

                            while (Buffer1Index < NumBytesRxd)
                            {
                                InputBuffer2[Buffer2Index] = InputBuffer[Buffer1Index];     // copy into main overall application buffer
                                Buffer1Index++;
                                Buffer2Index++;
                            }
                            TotalBytesRead = TotalBytesRead + NumBytesRxd;                  // Keep track of total
                        }
                        else
                            return 1;

                        QueueTimeOut++;
                        if (QueueTimeOut == 5000)
                            QueueTimeoutFlag = true;
                        else
                            Thread.Sleep(0);                                                // Avoids running Queue status checks back to back
                    }
                }
                // returning globals NumBytesRead and the buffer InputBuffer2
                NumBytesRead = TotalBytesRead;

                if (QueueTimeoutFlag == true)
                    return 1;
                else
                    return 0;
            }





            //###################################################################################################################################
            // Flush drivers receive buffer - Get queue status and read everything available and discard data

            private byte FlushBuffer()
            {
                ftStatus = myFtdiDevice.GetRxBytesAvailable(ref BytesAvailable);	 // Get the number of bytes in the receive buffer
                if (ftStatus != FTDI.FT_STATUS.FT_OK)
                    return 1;

                if (BytesAvailable > 0)
                {
                    ftStatus = myFtdiDevice.Read(InputBuffer, BytesAvailable, ref NumBytesRead);  	//Read out the data from receive buffer
                    if (ftStatus != FTDI.FT_STATUS.FT_OK)
                        return 1;       // error
                    else
                        return 0;       // all bytes successfully read
                }
                else
                {
                    return 0;           // there were no bytes to read
                }
            }

            #endregion

        }


    }
}
