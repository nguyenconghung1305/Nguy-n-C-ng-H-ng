--Câu 1--
CREATE PROCEDURE lab8_cau1
    @manv INT,
    @tennv NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @diachi NVARCHAR(100),
    @sodt NVARCHAR(20),
    @email NVARCHAR(50),
    @phong NVARCHAR(50),
    @flag BIT
AS
BEGIN
    SET NOCOUNT ON;  
    IF (@gioitinh != N'Nam' AND @gioitinh != N'Nữ')
    BEGIN
        SELECT 1 AS ErrorCode, 'Giới tính không hợp lệ' AS ErrorMessage;
        RETURN;
    END
    IF (@flag = 0)
    BEGIN
        INSERT INTO Nhanvien (manv, tennv, giotinh, diachi, sodt, email, phong)
        VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong);
        SELECT 0 AS ErrorCode, 'Thêm mới nhân viên thành công' AS ErrorMessage;
    END
    ELSE
    BEGIN
        UPDATE Nhanvien
        SET tennv = @tennv,
            giotinh = @gioitinh,
            diachi = @diachi,
            sodt = @sodt,
            email = @email,
            phong = @phong
        WHERE manv = @manv;
      
        SELECT 0 AS ErrorCode, 'Cập nhật thông tin nhân viên thành công' AS ErrorMessage;
    END
END


--Câu 2--
CREATE PROCEDURE lab8_cau2
    @masp INT,
    @tenhang NVARCHAR(50),
    @tensp NVARCHAR(50),
    @soluong INT,
    @mausac NVARCHAR(50),
    @giaban FLOAT,
    @donvitinh NVARCHAR(20),
    @mota NVARCHAR(100),
    @flag BIT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        SELECT 1 AS ErrorCode, 'Tên hãng sản xuất không tồn tại' AS ErrorMessage;
        RETURN;
    END
    IF (@soluong < 0)
    BEGIN
        SELECT 2 AS ErrorCode, 'Số lượng không hợp lệ' AS ErrorMessage;
        RETURN;
    END
    IF (@flag = 0)
    BEGIN
        INSERT INTO Sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang), @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota);
        SELECT 0 AS ErrorCode, 'Thêm mới sản phẩm thành công' AS ErrorMessage;
    END
    ELSE
    BEGIN
        UPDATE Sanpham
        SET mahangsx = (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang),
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE masp = @masp;
        SELECT 0 AS ErrorCode, 'Cập nhật thông tin sản phẩm thành công' AS ErrorMessage;
    END
END


--Câu 3--
CREATE PROCEDURE lab8_cau3
    @manv int,
    @result int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @count int;

    -- Kiểm tra nhanvien có tồn tại hay không
    SELECT @count = COUNT(*) FROM nhanvien WHERE manv = @manv;
    IF @count = 0
    BEGIN
        SET @result = 1; -- Trả về 1 nếu manv chưa tồn tại
        RETURN;
    END;

    -- Xóa các bản ghi liên quan trong bảng Nhap và Xuat
    DELETE FROM Nhap WHERE manv = @manv;
    DELETE FROM Xuat WHERE manv = @manv;

    -- Xóa nhân viên từ bảng nhanvien

	DELETE FROM nhanvien WHERE manv = @manv;

    SET @result = 0; -- Trả về 0 nếu xóa thành công
END


--Câu 4--
CREATE PROCEDURE lab8_cau4(@masp VARCHAR(10))
AS
BEGIN

    IF NOT EXISTS (SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        SELECT 1 AS 'ErrorCode'
        RETURN
    END
    
    DELETE FROM Nhap WHERE masp = @masp
    
    DELETE FROM Xuat WHERE masp = @masp
    
    DELETE FROM sanpham WHERE masp = @masp
    
    SELECT 0 AS 'ErrorCode'
END


--Câu 5--
CREATE PROCEDURE lab8_cau5
    @mahangsx varchar(10),
    @tenhang nvarchar(50),
    @diachi nvarchar(100),
    @sodt varchar(20),
    @email varchar(50)
AS
BEGIN
    IF EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        SELECT 1 AS [ErrorCode]
        RETURN
    END
    INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
    VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)
    SELECT 0 AS [ErrorCode]
    RETURN
END


--Câu 6--
CREATE PROCEDURE lab8_cau6
    @sohdn nvarchar(50),
    @masp nvarchar(50),
    @manv nvarchar(50),
    @ngaynhap date,
    @soluongN int,
    @dongiaN float
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        SELECT 1 AS ErrorCode, 'Mã sản phẩm không tồn tại' AS ErrorMessage
        RETURN
    END
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        SELECT 2 AS ErrorCode, 'Mã nhân viên không tồn tại' AS ErrorMessage
        RETURN
    END
    
    IF EXISTS (SELECT * FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        UPDATE Nhap
        SET masp = @masp,
            manv = @manv,
            ngaynhap = @ngaynhap,
            soluongN = @soluongN,
            dongiaN = @dongiaN
        WHERE sohdn = @sohdn
       
        SELECT 0 AS ErrorCode, 'Cập nhật dữ liệu thành công' AS ErrorMessage
        RETURN
    END
    ELSE
    BEGIN
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
        SELECT 0 AS ErrorCode, 'Thêm mới dữ liệu thành công' AS ErrorMessage
        RETURN
    END
END


--Câu 7--
CREATE PROCEDURE lab8_cau7
    @sohdx INT,
    @masp INT,
    @manv INT,
    @ngayxuat DATE,
    @soluongX INT
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 1 
    END
    
    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RETURN 2
    END
    
    IF @soluongX > (SELECT soluong FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 3 
    END

    IF EXISTS(SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        INSERT INTO Xuat(sohdx, masp, manv, ngayxuat, soluongX)
        VALUES(@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
    
    RETURN 0
END