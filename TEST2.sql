--CAU 1
CREATE TABLE [dbo].[HangXuat](
	[MaHD] [nchar](10) NOT NULL,
	[MaVT] [nchar](10) NOT NULL,
	[DonGia] [money] NULL,
	[SLBan] [tinyint] NULL,
 CONSTRAINT [PK_HangXuat] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaVT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HDBan]    Script Date: 13/12/2022 2:12:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HDBan](
	[MaHD] [nchar](10) NOT NULL,
	[NgayXuat] [smalldatetime] NULL,
	[HoTenKhach] [nchar](40) NULL,
 CONSTRAINT [PK_HDBan] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VatTu]    Script Date: 13/12/2022 2:12:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VatTu](
	[TenVT] [nchar](10) NULL,
	[MaVT] [nchar](10) NOT NULL,
	[DVTinh] [nchar](10) NULL,
	[SLCon] [smallint] NULL,
 CONSTRAINT [PK_VatTu] PRIMARY KEY CLUSTERED 
(
	[MaVT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[HangXuat] ([MaHD], [MaVT], [DonGia], [SLBan]) VALUES (N'01  ', N'01A ', 25000., 1)
INSERT [dbo].[HangXuat] ([MaHD], [MaVT], [DonGia], [SLBan]) VALUES (N'02  ', N'01b  ', 6000, 30)
INSERT [dbo].[HangXuat] ([MaHD], [MaVT], [DonGia], [SLBan]) VALUES (N'03  ', N'01C  ', 3000., 20)
INSERT [dbo].[HangXuat] ([MaHD], [MaVT], [DonGia], [SLBan]) VALUES (N'04  ', N'01D  ', 8000., 15)
GO
INSERT [dbo].[HDBan] ([MaHD], [NgayXuat], [HoTenKhach]) VALUES (N'001       ', CAST(N'2020-05-32T00:00:00' AS SmallDateTime), N'PHẠM MINH A                            ')
INSERT [dbo].[HDBan] ([MaHD], [NgayXuat], [HoTenKhach]) VALUES (N'002       ', CAST(N'2021-03-10T00:00:00' AS SmallDateTime), N'PHẠM MINH B                            ')
GO
INSERT [dbo].[VatTu] ([TenVT], [MaVT], [DVTinh], [SLCon]) VALUES (N'MÀN HÌNH   ', N'01A  ', N'cái ', 626)
INSERT [dbo].[VatTu] ([TenVT], [MaVT], [DVTinh], [SLCon]) VALUES (N'VI TÍNH ', N'01B  ', N'Cái  ', 882)
GO
USE [master]
GO
ALTER DATABASE [QLHANG] SET  READ_WRITE 
GO
--CÂU 2
use QLHANG
go
select top 1 MaHD, sum(DonGia) as TongTien from HangXuat group by MaHD, DonGia order by DonGia desc

--CÂU 3
CREATE FUNCTION f3 (
    @MAHD varchar(10)
)
RETURNS TABLE
AS
RETURN
    SELECT 
        HX.MAHD,
        HD.NGAYXUAT,
        HD.MAVT,
        HX.DONGIA,
        HX.SLBAN,  
        CASE
            WHEN WEEKDAY(HD.NGAYXUAT) = 0 THEN N'Thứ hai'            
            WHEN WEEKDAY(HD.NGAYXUAT) = 1 THEN N'Thứ ba'
            WHEN WEEKDAY(HD.NGAYXUAT) = 2 THEN N'Thứ tư'
            WHEN WEEKDAY(HD.NGAYXUAT) = 3 THEN N'Thứ năm'
            WHEN WEEKDAY(HD.NGAYXUAT) = 4 THEN N'Thứ sáu'
            WHEN WEEKDAY(HD.NGAYXUAT) = 5 THEN N'Thứ bảy'
            ELSE N'Chủ nhật'
        END AS NGAYTHU
    FROM HANGXUAT HX
    INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
    WHERE HX.MAHD = @MAHD;
--CÂU 4
CREATE PROCEDURE p4 
@thang int, @nam int 
AS
SELECT 
SUM(SLBAN * DONGIA)
FROM HANGXUAT HX
INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
where MONTH(HD.NGAYXUAT) = @THANG AND YEAR(HD.NGAYXUAT) = @NAM;

