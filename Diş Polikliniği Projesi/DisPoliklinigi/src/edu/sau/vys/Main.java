package edu.sau.vys;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Scanner;


public class Main {

    private Connection con = null;
    private Statement statement = null;
    private PreparedStatement preparedStatement = null;

    public void preparedCalisanlariGetir(int id) {

        String sorgu = "SELECT   \"poliklinikAdi\",\n" +
                "         \"ad\",\n" +
                "         \"soyad\",\n" +
                "         \"yas\",\n" +
                "         \"telefon\",\n" +
                "         \"adres\",\n" +
                "         \"email\",\n" +
                "         \"ilceAdi\",\n" +
                "         \"ilAdi\",\n" +
                "         \"kisiTuru\",\n" +
                "         \"Kisi\".\"kisiNo\"\n" +
                "FROM     \"DisPoliklinigi\" \n" +
                "INNER JOIN \"Kisi\"  ON \"DisPoliklinigi\".\"poliklinikNo\" = \"Kisi\".\"poliklinikNo\" \n" +
                "INNER JOIN \"IletisimBilgileri\"  ON \"Kisi\".\"kisiNo\" = \"IletisimBilgileri\".\"kisiNo\" \n" +
                "INNER JOIN \"Ilce\"  ON \"Ilce\".\"ilceNo\" = \"IletisimBilgileri\".\"ilceNo\" \n" +
                "INNER JOIN \"Il\"  ON \"Il\".\"ilNo\" = \"Ilce\".\"il\"\n" +
                "WHERE \"Kisi\".\"kisiNo\" = ?";


        try {
            preparedStatement = con.prepareStatement(sorgu);
            preparedStatement.setInt(1, id);

            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {

                int kisiNo = rs.getInt("kisiNo");
                String ad = rs.getString("ad");
                String soyad = rs.getString("soyad");
                int yas = rs.getInt("yas");
                String kisiTuru = rs.getString("kisiTuru");
                String poliklinikAdi = rs.getString("poliklinikAdi");
                String telefon = rs.getString("telefon");
                String email = rs.getString("email");
                String adres = rs.getString("adres");
                String ilAdi = rs.getString("ilAdi");
                String ilceAdi = rs.getString("ilceAdi");

                System.out.println("\nKi??iNo : " + kisiNo + " Ad : " + ad + " Soyad: " + soyad + " Ya?? : " +
                        yas + "\n Ki??iT??r?? : " + kisiTuru + " PoliklinikAd?? : " + poliklinikAdi + "\n Telefon : " + telefon + " Email : " + email +
                        "\n Adres : " + adres + " ??lAdi : " + ilAdi + " ??l??eAdi : " + ilceAdi);

            }


        } catch (SQLException ex)
            {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            }

    }

    public void kisiSil(int id) {

        String sorgu = "Delete from \"Kisi\" where \"kisiNo\" = ?";

        try {
            preparedStatement = con.prepareStatement(sorgu);
            preparedStatement.setInt(1, id);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next())
            {
                String ad = rs.getString("ad");

                System.out.println(ad +" 'l?? ki??i silinmi??tir...");

            }



        } catch (SQLException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }


    }


    public void calisanlariGetir() {

        String sorgu = "Select * From \"Kisi\" order by  \"kisiNo\" ASC ";

        try {
            statement = con.createStatement();

            ResultSet rs = statement.executeQuery(sorgu);

            while (rs.next()) {

                int kisiNo = rs.getInt("kisiNo");
                int poliklinikNo = rs.getInt("poliklinikNo");
                String ad = rs.getString("ad");
                String soyad = rs.getString("soyad");
                int yas = rs.getInt("yas");
                int maas = rs.getInt("maas");
                String kisiTuru = rs.getString("kisiTuru");

                System.out.println("kisiNo : " + kisiNo + " poliklinikNo : " + poliklinikNo + " Ad: " + ad + " Soyad : " + soyad + " yas : " + yas + " maas : " + maas + " kisiTuru : " + kisiTuru);


            }


        } catch (SQLException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }



    }

    public void kisiEkle( int PoliklinikNo,String Ad,String Soyad,int Yas ,int Maas ,String KisiTuru) {



        try {
            statement = con.createStatement();
            int poliklinikNo = PoliklinikNo;
            String ad = Ad;
            String soyad = Soyad;
            int yas = Yas;
            int maas = Maas;
            String kisiTuru =  KisiTuru;
            // Insert Into calisanlar (ad,soyad,email) VALUES('Yusuf','??etinkaya','mucahit@gmail.com')
            String sorgu = "Insert Into \"Kisi\" (\"poliklinikNo\",ad,soyad,yas,maas,\"kisiTuru\") VALUES(" + "'" + poliklinikNo + "'," + "'" + ad + "',"  + "'" + soyad + "'," + "'" + yas + "'," + "'" + maas + "'," + "'" + kisiTuru + "')";

            statement.executeUpdate(sorgu);



        } catch (SQLException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }


    }

    public Main() {

        try {
                con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/DisPoliklinigi",
                    "postgres", "12345");

            if (con != null)
                System.out.println("Veritaban??na ba??land??!");
            else
                System.out.println("Ba??lant?? giri??imi ba??ar??s??z!");

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public static void main(String[] args) {

        Main main = new Main();

        Scanner scanner = new Scanner(System.in);


        System.out.println("\nDi?? Poliklini??ine Ho??geldiniz...\n");


        String islemler = "I??lemler : \n"+
                          "1. T??m Ki??ileri G??ster\n"+
                          "2. Ki??i Ekle\n"+
                          "3. Ki??i ????kar\n"+
                          "4. Ki??iNo'su girilen ki??inin bilgilerini G??ster \n"+
                          "????kmak I??in -1 ' e Bas??n??z...\n";
        int islem;
        while (true)
        {
            System.out.println("\n"+islemler);

            System.out.print("Islemi Giriniz : ");
            islem = scanner.nextInt();


            if (islem == -1){
                break;
            }
            else if (islem == 1)
            {
                main.calisanlariGetir();
            }
            else if (islem == 2)
            {
                System.out.println("\nA????a????daki Bilgileri Doldurunuz...\n");

                System.out.print("PoliklinikNo : ");
                int poliklinikNo = scanner.nextInt();
                scanner.nextLine();

                System.out.print("Ad : ");
                String ad = scanner.nextLine();

                System.out.print("Soyad : ");
                String soyad = scanner.nextLine();

                System.out.print("Ya?? : ");
                int yas = scanner.nextInt();

                System.out.print("Maas : ");
                int maas = scanner.nextInt();
                scanner.nextLine();

                System.out.print("Ki??iT??r?? : ");
                String kisiTuru = scanner.nextLine();

                main.kisiEkle(poliklinikNo,ad,soyad,yas,maas,kisiTuru);

            }
            else if (islem == 3)
            {
                System.out.print("\nSilmek Istediginiz Ki??inin kisiNo'su : ");
                int kisiNo = scanner.nextInt();

                main.kisiSil(kisiNo);

            }
            else if (islem == 4)
            {
                System.out.print("\nBilgilerini G??rmek Istediginiz Ki??inin kisiNo'su : ");
                int kisiNo = scanner.nextInt();

                main.preparedCalisanlariGetir(kisiNo);
            }
            else
            {
                System.out.println("\nGe??ersiz Islem...\n");
            }

        }

    }
}
