namespace I2C_RegSetting
{
    partial class FormCellEdit
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
            this.numericUpDown_R = new System.Windows.Forms.NumericUpDown();
            this.numericUpDown_G = new System.Windows.Forms.NumericUpDown();
            this.numericUpDown_B = new System.Windows.Forms.NumericUpDown();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.buttonSet = new System.Windows.Forms.Button();
            this.buttonClear = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown_R)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown_G)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown_B)).BeginInit();
            this.SuspendLayout();
            // 
            // numericUpDown_R
            // 
            this.numericUpDown_R.Location = new System.Drawing.Point(12, 20);
            this.numericUpDown_R.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.numericUpDown_R.Name = "numericUpDown_R";
            this.numericUpDown_R.Size = new System.Drawing.Size(54, 21);
            this.numericUpDown_R.TabIndex = 0;
            this.numericUpDown_R.Value = new decimal(new int[] {
            255,
            0,
            0,
            0});
            // 
            // numericUpDown_G
            // 
            this.numericUpDown_G.Location = new System.Drawing.Point(72, 20);
            this.numericUpDown_G.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.numericUpDown_G.Name = "numericUpDown_G";
            this.numericUpDown_G.Size = new System.Drawing.Size(54, 21);
            this.numericUpDown_G.TabIndex = 1;
            this.numericUpDown_G.Value = new decimal(new int[] {
            255,
            0,
            0,
            0});
            // 
            // numericUpDown_B
            // 
            this.numericUpDown_B.Location = new System.Drawing.Point(132, 20);
            this.numericUpDown_B.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.numericUpDown_B.Name = "numericUpDown_B";
            this.numericUpDown_B.Size = new System.Drawing.Size(54, 21);
            this.numericUpDown_B.TabIndex = 2;
            this.numericUpDown_B.Value = new decimal(new int[] {
            255,
            0,
            0,
            0});
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(28, 5);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(13, 12);
            this.label1.TabIndex = 3;
            this.label1.Text = "R";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(89, 5);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(14, 12);
            this.label2.TabIndex = 4;
            this.label2.Text = "G";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(150, 5);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(13, 12);
            this.label3.TabIndex = 5;
            this.label3.Text = "B";
            // 
            // buttonSet
            // 
            this.buttonSet.Location = new System.Drawing.Point(107, 47);
            this.buttonSet.Name = "buttonSet";
            this.buttonSet.Size = new System.Drawing.Size(79, 22);
            this.buttonSet.TabIndex = 6;
            this.buttonSet.Text = "SET";
            this.buttonSet.UseVisualStyleBackColor = true;
            this.buttonSet.Click += new System.EventHandler(this.buttonSet_Click);
            // 
            // buttonClear
            // 
            this.buttonClear.Location = new System.Drawing.Point(12, 47);
            this.buttonClear.Name = "buttonClear";
            this.buttonClear.Size = new System.Drawing.Size(80, 22);
            this.buttonClear.TabIndex = 7;
            this.buttonClear.Text = "CLEAR";
            this.buttonClear.UseVisualStyleBackColor = true;
            this.buttonClear.Click += new System.EventHandler(this.buttonClear_Click);
            // 
            // FormCellEdit
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.ClientSize = new System.Drawing.Size(199, 74);
            this.Controls.Add(this.buttonClear);
            this.Controls.Add(this.buttonSet);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.numericUpDown_B);
            this.Controls.Add(this.numericUpDown_G);
            this.Controls.Add(this.numericUpDown_R);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "FormCellEdit";
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown_R)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown_G)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDown_B)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.NumericUpDown numericUpDown_R;
        private System.Windows.Forms.NumericUpDown numericUpDown_G;
        private System.Windows.Forms.NumericUpDown numericUpDown_B;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button buttonSet;
        private System.Windows.Forms.Button buttonClear;
    }
}