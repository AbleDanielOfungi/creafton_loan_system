import 'package:creafton_financial_services/models/expenditure.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class ExpenditurePdfService {



static Future<void> generate(
List<Expenditure> expenses
) async{


final pdf =
pw.Document();



pdf.addPage(

pw.MultiPage(

build:(context)=>[


pw.Text(

"Expenditure Report",

style:
pw.TextStyle(
fontSize:20,
fontWeight:
pw.FontWeight.bold
)

),



pw.SizedBox(height:20),




pw.Table.fromTextArray(

headers:[

"Date",

"Title",

"Amount",

"Payment"

],



data:

expenses.map((e)=>[

e.expenseDate,

e.title,

"UGX ${e.amount}",

e.paymentMethod ?? "-"

]).toList()



)



]


)


);



await Printing.layoutPdf(

onLayout:(format)=>pdf.save()

);



}



}