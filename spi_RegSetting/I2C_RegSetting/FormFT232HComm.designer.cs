namespace I2C_RegSetting
{
    partial class FormFT232HComm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            this.mConnectDev = new System.Windows.Forms.TextBox();
            this.mConnectInfo = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.mLogText = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.comboBox_deviceName = new System.Windows.Forms.ComboBox();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.btnTab1WriteTest = new System.Windows.Forms.Button();
            this.btnTab1ReadTest = new System.Windows.Forms.Button();
            this.tB_tab1_data = new System.Windows.Forms.TextBox();
            this.tB_tab1_addr = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.label6 = new System.Windows.Forms.Label();
            this.button5 = new System.Windows.Forms.Button();
            this.btnTab1MultiRead = new System.Windows.Forms.Button();
            this.btnTab1MultiWrite = new System.Windows.Forms.Button();
            this.listView1 = new System.Windows.Forms.ListView();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.label7 = new System.Windows.Forms.Label();
            this.listView2 = new System.Windows.Forms.ListView();
            this.btnTab2MultiRead = new System.Windows.Forms.Button();
            this.btnTab2MultiWrite = new System.Windows.Forms.Button();
            this.btnTab2WriteTest = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.btnTab2ReadTest = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.tB_tab2_addr = new System.Windows.Forms.TextBox();
            this.tB_tab2_data = new System.Windows.Forms.TextBox();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.btnTab3MultiRead = new System.Windows.Forms.Button();
            this.btnTab3MultiWrite = new System.Windows.Forms.Button();
            this.btnTab3WriteTest = new System.Windows.Forms.Button();
            this.label9 = new System.Windows.Forms.Label();
            this.btnTab3ReadTest = new System.Windows.Forms.Button();
            this.label10 = new System.Windows.Forms.Label();
            this.tB_tab3_addr = new System.Windows.Forms.TextBox();
            this.tB_tab3_data = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.tabPage4 = new System.Windows.Forms.TabPage();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label11 = new System.Windows.Forms.Label();
            this.button3 = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.button6 = new System.Windows.Forms.Button();
            this.label12 = new System.Windows.Forms.Label();
            this.button7 = new System.Windows.Forms.Button();
            this.label13 = new System.Windows.Forms.Label();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.listView3 = new System.Windows.Forms.ListView();
            this.groupBox1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.tabPage3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.tabPage4.SuspendLayout();
            this.SuspendLayout();
            // 
            // mConnectDev
            // 
            this.mConnectDev.Location = new System.Drawing.Point(133, 47);
            this.mConnectDev.Name = "mConnectDev";
            this.mConnectDev.Size = new System.Drawing.Size(55, 21);
            this.mConnectDev.TabIndex = 0;
            // 
            // mConnectInfo
            // 
            this.mConnectInfo.AutoSize = true;
            this.mConnectInfo.Location = new System.Drawing.Point(9, 25);
            this.mConnectInfo.Name = "mConnectInfo";
            this.mConnectInfo.Size = new System.Drawing.Size(83, 12);
            this.mConnectInfo.TabIndex = 1;
            this.mConnectInfo.Text = "mConnectInfo";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(85, 50);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(42, 12);
            this.label2.TabIndex = 2;
            this.label2.Text = "dev_ID";
            // 
            // mLogText
            // 
            this.mLogText.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mLogText.Location = new System.Drawing.Point(594, 91);
            this.mLogText.Multiline = true;
            this.mLogText.Name = "mLogText";
            this.mLogText.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.mLogText.Size = new System.Drawing.Size(472, 653);
            this.mLogText.TabIndex = 3;
            // 
            // button1
            // 
            this.button1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.button1.Location = new System.Drawing.Point(230, 43);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(65, 27);
            this.button1.TabIndex = 4;
            this.button1.Text = "Open";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // button2
            // 
            this.button2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.button2.Location = new System.Drawing.Point(296, 43);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(65, 27);
            this.button2.TabIndex = 5;
            this.button2.Text = "Close";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.comboBox_deviceName);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.mConnectInfo);
            this.groupBox1.Controls.Add(this.mConnectDev);
            this.groupBox1.Controls.Add(this.button2);
            this.groupBox1.Controls.Add(this.button1);
            this.groupBox1.Location = new System.Drawing.Point(699, 9);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(367, 76);
            this.groupBox1.TabIndex = 8;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "FT232H Connect";
            // 
            // comboBox_deviceName
            // 
            this.comboBox_deviceName.FormattingEnabled = true;
            this.comboBox_deviceName.Location = new System.Drawing.Point(133, 17);
            this.comboBox_deviceName.Name = "comboBox_deviceName";
            this.comboBox_deviceName.Size = new System.Drawing.Size(227, 20);
            this.comboBox_deviceName.TabIndex = 6;
            // 
            // btnTab1WriteTest
            // 
            this.btnTab1WriteTest.Location = new System.Drawing.Point(6, 27);
            this.btnTab1WriteTest.Name = "btnTab1WriteTest";
            this.btnTab1WriteTest.Size = new System.Drawing.Size(93, 53);
            this.btnTab1WriteTest.TabIndex = 9;
            this.btnTab1WriteTest.Text = "Write Test";
            this.btnTab1WriteTest.UseVisualStyleBackColor = true;
            this.btnTab1WriteTest.Click += new System.EventHandler(this.btnTab1WriteTest_Click);
            // 
            // btnTab1ReadTest
            // 
            this.btnTab1ReadTest.Location = new System.Drawing.Point(240, 28);
            this.btnTab1ReadTest.Name = "btnTab1ReadTest";
            this.btnTab1ReadTest.Size = new System.Drawing.Size(93, 53);
            this.btnTab1ReadTest.TabIndex = 13;
            this.btnTab1ReadTest.Text = "Read Test";
            this.btnTab1ReadTest.UseVisualStyleBackColor = true;
            this.btnTab1ReadTest.Click += new System.EventHandler(this.btnTab1ReadTest_Click);
            // 
            // tB_tab1_data
            // 
            this.tB_tab1_data.Location = new System.Drawing.Point(148, 57);
            this.tB_tab1_data.Name = "tB_tab1_data";
            this.tB_tab1_data.Size = new System.Drawing.Size(76, 21);
            this.tB_tab1_data.TabIndex = 18;
            this.tB_tab1_data.Text = "0xC0DE";
            // 
            // tB_tab1_addr
            // 
            this.tB_tab1_addr.Location = new System.Drawing.Point(148, 31);
            this.tB_tab1_addr.Name = "tB_tab1_addr";
            this.tB_tab1_addr.Size = new System.Drawing.Size(76, 21);
            this.tB_tab1_addr.TabIndex = 19;
            this.tB_tab1_addr.Text = "0x0000";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(105, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(37, 12);
            this.label1.TabIndex = 20;
            this.label1.Text = "ADDR";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(105, 60);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(37, 12);
            this.label3.TabIndex = 21;
            this.label3.Text = "DATA";
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Controls.Add(this.tabPage3);
            this.tabControl1.Controls.Add(this.tabPage4);
            this.tabControl1.Location = new System.Drawing.Point(3, 3);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(585, 741);
            this.tabControl1.TabIndex = 22;
            this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.label6);
            this.tabPage1.Controls.Add(this.button5);
            this.tabPage1.Controls.Add(this.btnTab1MultiRead);
            this.tabPage1.Controls.Add(this.btnTab1MultiWrite);
            this.tabPage1.Controls.Add(this.listView1);
            this.tabPage1.Controls.Add(this.btnTab1WriteTest);
            this.tabPage1.Controls.Add(this.label3);
            this.tabPage1.Controls.Add(this.btnTab1ReadTest);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Controls.Add(this.tB_tab1_addr);
            this.tabPage1.Controls.Add(this.tB_tab1_data);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(577, 715);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Reg0";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(6, 4);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(231, 12);
            this.label6.TabIndex = 26;
            this.label6.Text = "memory map : B\"0000_0000_0000_XXXX\"";
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(476, 164);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(57, 47);
            this.button5.TabIndex = 25;
            this.button5.Text = "button5";
            this.button5.UseVisualStyleBackColor = true;
            this.button5.Click += new System.EventHandler(this.button5_Click);
            // 
            // btnTab1MultiRead
            // 
            this.btnTab1MultiRead.Location = new System.Drawing.Point(240, 94);
            this.btnTab1MultiRead.Name = "btnTab1MultiRead";
            this.btnTab1MultiRead.Size = new System.Drawing.Size(93, 53);
            this.btnTab1MultiRead.TabIndex = 24;
            this.btnTab1MultiRead.Text = "Multi Read";
            this.btnTab1MultiRead.UseVisualStyleBackColor = true;
            this.btnTab1MultiRead.Click += new System.EventHandler(this.btnTab1MultiRead_Click);
            // 
            // btnTab1MultiWrite
            // 
            this.btnTab1MultiWrite.Location = new System.Drawing.Point(6, 94);
            this.btnTab1MultiWrite.Name = "btnTab1MultiWrite";
            this.btnTab1MultiWrite.Size = new System.Drawing.Size(93, 53);
            this.btnTab1MultiWrite.TabIndex = 23;
            this.btnTab1MultiWrite.Text = "Multi Write";
            this.btnTab1MultiWrite.UseVisualStyleBackColor = true;
            this.btnTab1MultiWrite.Click += new System.EventHandler(this.btnTab1MultiWrite_Click);
            // 
            // listView1
            // 
            this.listView1.Location = new System.Drawing.Point(6, 167);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(428, 545);
            this.listView1.TabIndex = 22;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.ListView1_MouseDoubleClick);
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.label7);
            this.tabPage2.Controls.Add(this.listView2);
            this.tabPage2.Controls.Add(this.btnTab2MultiRead);
            this.tabPage2.Controls.Add(this.btnTab2MultiWrite);
            this.tabPage2.Controls.Add(this.btnTab2WriteTest);
            this.tabPage2.Controls.Add(this.label4);
            this.tabPage2.Controls.Add(this.btnTab2ReadTest);
            this.tabPage2.Controls.Add(this.label5);
            this.tabPage2.Controls.Add(this.tB_tab2_addr);
            this.tabPage2.Controls.Add(this.tB_tab2_data);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(577, 715);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "DAC";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(6, 4);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(231, 12);
            this.label7.TabIndex = 34;
            this.label7.Text = "memory map : B\"0000_0000_0001_XXXX\"";
            // 
            // listView2
            // 
            this.listView2.Location = new System.Drawing.Point(6, 167);
            this.listView2.Name = "listView2";
            this.listView2.Size = new System.Drawing.Size(428, 545);
            this.listView2.TabIndex = 33;
            this.listView2.UseCompatibleStateImageBehavior = false;
            this.listView2.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.ListView2_MouseDoubleClick);
            // 
            // btnTab2MultiRead
            // 
            this.btnTab2MultiRead.Location = new System.Drawing.Point(240, 94);
            this.btnTab2MultiRead.Name = "btnTab2MultiRead";
            this.btnTab2MultiRead.Size = new System.Drawing.Size(93, 53);
            this.btnTab2MultiRead.TabIndex = 32;
            this.btnTab2MultiRead.Text = "Multi Read";
            this.btnTab2MultiRead.UseVisualStyleBackColor = true;
            this.btnTab2MultiRead.Click += new System.EventHandler(this.btnTab2MultiRead_Click);
            // 
            // btnTab2MultiWrite
            // 
            this.btnTab2MultiWrite.Location = new System.Drawing.Point(6, 94);
            this.btnTab2MultiWrite.Name = "btnTab2MultiWrite";
            this.btnTab2MultiWrite.Size = new System.Drawing.Size(93, 53);
            this.btnTab2MultiWrite.TabIndex = 31;
            this.btnTab2MultiWrite.Text = "Multi Write";
            this.btnTab2MultiWrite.UseVisualStyleBackColor = true;
            this.btnTab2MultiWrite.Click += new System.EventHandler(this.btnTab2MultiWrite_Click);
            // 
            // btnTab2WriteTest
            // 
            this.btnTab2WriteTest.Location = new System.Drawing.Point(6, 27);
            this.btnTab2WriteTest.Name = "btnTab2WriteTest";
            this.btnTab2WriteTest.Size = new System.Drawing.Size(93, 53);
            this.btnTab2WriteTest.TabIndex = 25;
            this.btnTab2WriteTest.Text = "Write Test";
            this.btnTab2WriteTest.UseVisualStyleBackColor = true;
            this.btnTab2WriteTest.Click += new System.EventHandler(this.btnTab2WriteTest_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(105, 60);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(37, 12);
            this.label4.TabIndex = 30;
            this.label4.Text = "DATA";
            // 
            // btnTab2ReadTest
            // 
            this.btnTab2ReadTest.Location = new System.Drawing.Point(240, 28);
            this.btnTab2ReadTest.Name = "btnTab2ReadTest";
            this.btnTab2ReadTest.Size = new System.Drawing.Size(93, 53);
            this.btnTab2ReadTest.TabIndex = 26;
            this.btnTab2ReadTest.Text = "Read Test";
            this.btnTab2ReadTest.UseVisualStyleBackColor = true;
            this.btnTab2ReadTest.Click += new System.EventHandler(this.btnTab2ReadTest_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(105, 34);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(37, 12);
            this.label5.TabIndex = 29;
            this.label5.Text = "ADDR";
            // 
            // tB_tab2_addr
            // 
            this.tB_tab2_addr.Location = new System.Drawing.Point(148, 31);
            this.tB_tab2_addr.Name = "tB_tab2_addr";
            this.tB_tab2_addr.Size = new System.Drawing.Size(76, 21);
            this.tB_tab2_addr.TabIndex = 28;
            this.tB_tab2_addr.Text = "0x0010";
            // 
            // tB_tab2_data
            // 
            this.tB_tab2_data.Location = new System.Drawing.Point(148, 57);
            this.tB_tab2_data.Name = "tB_tab2_data";
            this.tB_tab2_data.Size = new System.Drawing.Size(76, 21);
            this.tB_tab2_data.TabIndex = 27;
            this.tB_tab2_data.Text = "0x55AA";
            // 
            // tabPage3
            // 
            this.tabPage3.Controls.Add(this.btnTab3MultiRead);
            this.tabPage3.Controls.Add(this.btnTab3MultiWrite);
            this.tabPage3.Controls.Add(this.btnTab3WriteTest);
            this.tabPage3.Controls.Add(this.label9);
            this.tabPage3.Controls.Add(this.btnTab3ReadTest);
            this.tabPage3.Controls.Add(this.label10);
            this.tabPage3.Controls.Add(this.tB_tab3_addr);
            this.tabPage3.Controls.Add(this.tB_tab3_data);
            this.tabPage3.Controls.Add(this.label8);
            this.tabPage3.Controls.Add(this.dataGridView1);
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage3.Size = new System.Drawing.Size(577, 715);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "ADC";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // btnTab3MultiRead
            // 
            this.btnTab3MultiRead.Location = new System.Drawing.Point(240, 94);
            this.btnTab3MultiRead.Name = "btnTab3MultiRead";
            this.btnTab3MultiRead.Size = new System.Drawing.Size(93, 53);
            this.btnTab3MultiRead.TabIndex = 43;
            this.btnTab3MultiRead.Text = "Multi Read";
            this.btnTab3MultiRead.UseVisualStyleBackColor = true;
            // 
            // btnTab3MultiWrite
            // 
            this.btnTab3MultiWrite.Location = new System.Drawing.Point(6, 94);
            this.btnTab3MultiWrite.Name = "btnTab3MultiWrite";
            this.btnTab3MultiWrite.Size = new System.Drawing.Size(93, 53);
            this.btnTab3MultiWrite.TabIndex = 42;
            this.btnTab3MultiWrite.Text = "Multi Write";
            this.btnTab3MultiWrite.UseVisualStyleBackColor = true;
            // 
            // btnTab3WriteTest
            // 
            this.btnTab3WriteTest.Location = new System.Drawing.Point(6, 27);
            this.btnTab3WriteTest.Name = "btnTab3WriteTest";
            this.btnTab3WriteTest.Size = new System.Drawing.Size(93, 53);
            this.btnTab3WriteTest.TabIndex = 36;
            this.btnTab3WriteTest.Text = "Write Test";
            this.btnTab3WriteTest.UseVisualStyleBackColor = true;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(105, 60);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(37, 12);
            this.label9.TabIndex = 41;
            this.label9.Text = "DATA";
            // 
            // btnTab3ReadTest
            // 
            this.btnTab3ReadTest.Location = new System.Drawing.Point(240, 28);
            this.btnTab3ReadTest.Name = "btnTab3ReadTest";
            this.btnTab3ReadTest.Size = new System.Drawing.Size(93, 53);
            this.btnTab3ReadTest.TabIndex = 37;
            this.btnTab3ReadTest.Text = "Read Test";
            this.btnTab3ReadTest.UseVisualStyleBackColor = true;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(105, 34);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(37, 12);
            this.label10.TabIndex = 40;
            this.label10.Text = "ADDR";
            // 
            // tB_tab3_addr
            // 
            this.tB_tab3_addr.Location = new System.Drawing.Point(148, 31);
            this.tB_tab3_addr.Name = "tB_tab3_addr";
            this.tB_tab3_addr.Size = new System.Drawing.Size(76, 21);
            this.tB_tab3_addr.TabIndex = 39;
            this.tB_tab3_addr.Text = "0x2000";
            // 
            // tB_tab3_data
            // 
            this.tB_tab3_data.Location = new System.Drawing.Point(148, 57);
            this.tB_tab3_data.Name = "tB_tab3_data";
            this.tB_tab3_data.Size = new System.Drawing.Size(76, 21);
            this.tB_tab3_data.TabIndex = 38;
            this.tB_tab3_data.Text = "0xC0DE";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(6, 4);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(249, 12);
            this.label8.TabIndex = 35;
            this.label8.Text = "memory map : B\"001X_XXXX_XXXX_XXXX\"";
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle5.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle5.Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            dataGridViewCellStyle5.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.Color.Transparent;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridView1.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle5;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.White;
            dataGridViewCellStyle6.Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            dataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dataGridView1.DefaultCellStyle = dataGridViewCellStyle6;
            this.dataGridView1.Location = new System.Drawing.Point(6, 431);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowTemplate.Height = 23;
            this.dataGridView1.Size = new System.Drawing.Size(565, 278);
            this.dataGridView1.TabIndex = 13;
            // 
            // tabPage4
            // 
            this.tabPage4.Controls.Add(this.listView3);
            this.tabPage4.Controls.Add(this.button3);
            this.tabPage4.Controls.Add(this.button4);
            this.tabPage4.Controls.Add(this.button6);
            this.tabPage4.Controls.Add(this.label12);
            this.tabPage4.Controls.Add(this.button7);
            this.tabPage4.Controls.Add(this.label13);
            this.tabPage4.Controls.Add(this.textBox2);
            this.tabPage4.Controls.Add(this.textBox3);
            this.tabPage4.Controls.Add(this.label11);
            this.tabPage4.Location = new System.Drawing.Point(4, 22);
            this.tabPage4.Name = "tabPage4";
            this.tabPage4.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage4.Size = new System.Drawing.Size(577, 715);
            this.tabPage4.TabIndex = 3;
            this.tabPage4.Text = "Video";
            this.tabPage4.UseVisualStyleBackColor = true;
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(594, 59);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(76, 21);
            this.textBox1.TabIndex = 27;
            this.textBox1.KeyDown += new System.Windows.Forms.KeyEventHandler(this.TextBox1_KeyDown);
            this.textBox1.Leave += new System.EventHandler(this.textBox1_Leave);
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(6, 3);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(237, 12);
            this.label11.TabIndex = 27;
            this.label11.Text = "memory map : B\"0000_0000_1XXX_XXXX\"";
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(242, 94);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(93, 53);
            this.button3.TabIndex = 35;
            this.button3.Text = "Multi Read";
            this.button3.UseVisualStyleBackColor = true;
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(8, 94);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(93, 53);
            this.button4.TabIndex = 34;
            this.button4.Text = "Multi Write";
            this.button4.UseVisualStyleBackColor = true;
            // 
            // button6
            // 
            this.button6.Location = new System.Drawing.Point(8, 27);
            this.button6.Name = "button6";
            this.button6.Size = new System.Drawing.Size(93, 53);
            this.button6.TabIndex = 28;
            this.button6.Text = "Write Test";
            this.button6.UseVisualStyleBackColor = true;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(107, 60);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(37, 12);
            this.label12.TabIndex = 33;
            this.label12.Text = "DATA";
            // 
            // button7
            // 
            this.button7.Location = new System.Drawing.Point(242, 28);
            this.button7.Name = "button7";
            this.button7.Size = new System.Drawing.Size(93, 53);
            this.button7.TabIndex = 29;
            this.button7.Text = "Read Test";
            this.button7.UseVisualStyleBackColor = true;
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(107, 34);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(37, 12);
            this.label13.TabIndex = 32;
            this.label13.Text = "ADDR";
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(150, 31);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(76, 21);
            this.textBox2.TabIndex = 31;
            this.textBox2.Text = "0x0000";
            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(150, 57);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new System.Drawing.Size(76, 21);
            this.textBox3.TabIndex = 30;
            this.textBox3.Text = "0xC0DE";
            // 
            // listView3
            // 
            this.listView3.Location = new System.Drawing.Point(8, 153);
            this.listView3.Name = "listView3";
            this.listView3.Size = new System.Drawing.Size(563, 556);
            this.listView3.TabIndex = 36;
            this.listView3.UseCompatibleStateImageBehavior = false;
            // 
            // FormFT232HComm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1078, 750);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.mLogText);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "FormFT232HComm";
            this.Text = "FormFT232HComm";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.tabPage3.ResumeLayout(false);
            this.tabPage3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.tabPage4.ResumeLayout(false);
            this.tabPage4.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox mConnectDev;
        private System.Windows.Forms.Label mConnectInfo;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox mLogText;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ComboBox comboBox_deviceName;
        private System.Windows.Forms.ToolTip toolTip1;
        private System.Windows.Forms.Button btnTab1WriteTest;
        private System.Windows.Forms.Button btnTab1ReadTest;
        private System.Windows.Forms.TextBox tB_tab1_data;
        private System.Windows.Forms.TextBox tB_tab1_addr;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ListView listView1;
        private System.Windows.Forms.Button btnTab1MultiRead;
        private System.Windows.Forms.Button btnTab1MultiWrite;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.ListView listView2;
        private System.Windows.Forms.Button btnTab2MultiRead;
        private System.Windows.Forms.Button btnTab2MultiWrite;
        private System.Windows.Forms.Button btnTab2WriteTest;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnTab2ReadTest;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox tB_tab2_addr;
        private System.Windows.Forms.TextBox tB_tab2_data;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Button btnTab3MultiRead;
        private System.Windows.Forms.Button btnTab3MultiWrite;
        private System.Windows.Forms.Button btnTab3WriteTest;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Button btnTab3ReadTest;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.TextBox tB_tab3_addr;
        private System.Windows.Forms.TextBox tB_tab3_data;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TabPage tabPage4;
        private System.Windows.Forms.ListView listView3;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Button button6;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Button button7;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.Label label11;
    }
}