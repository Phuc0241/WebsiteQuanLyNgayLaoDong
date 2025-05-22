namespace QuanLyNgayLaoDong.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("TaoDotNgayLaoDong")]
    public partial class TaoDotNgayLaoDong
    {
        public int ID { get; set; }

        [Required]
        [StringLength(255)]
        public string TenDotLaoDong { get; set; }

        [StringLength(500)]
        public string MoTa { get; set; }

        [Column(TypeName = "date")]
        public DateTime NgayBatDau { get; set; }

        [Column(TypeName = "date")]
        public DateTime NgayKetThuc { get; set; }

        public DateTime? NgayTao { get; set; }

        public DateTime? NgayCapNhat { get; set; }

        public int? NguoiTao { get; set; }

        public virtual TaiKhoan TaiKhoan { get; set; }
    }
}
