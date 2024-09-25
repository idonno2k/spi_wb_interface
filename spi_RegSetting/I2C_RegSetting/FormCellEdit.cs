using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace I2C_RegSetting
{
    public partial class FormCellEdit : Form
    {
        private FormFT232HComm mMainWindow;
        private Point CellPos;
        public FormCellEdit(FormFT232HComm mainForm,Point pos)
        {
            mMainWindow = mainForm;
            CellPos = pos;
            InitializeComponent();
        }

        private void buttonClear_Click(object sender, EventArgs e)
        {
            numericUpDown_R.Value = 255;
            numericUpDown_G.Value = 255;
            numericUpDown_B.Value = 255;
        }

        private void buttonSet_Click(object sender, EventArgs e)
        {
            Color myArgbColor = new Color();
            myArgbColor = Color.FromArgb(255, (int)numericUpDown_R.Value, (int)numericUpDown_G.Value, (int)numericUpDown_B.Value);

            mMainWindow.setDataGridView1_CellBackColor(CellPos.X, CellPos.Y, myArgbColor);

            this.Close();
        }
    }
}
