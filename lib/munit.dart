class munit{

  void testString(){
    List<int> a = [1,2,3];

    String b = a.map((e) => e).join(",");
    print("string b is :$b");

  }

}