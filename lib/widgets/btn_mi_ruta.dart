part of 'widgets.dart';

class BtnMiRuta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(Icons.map_rounded, color: Colors.black87),
          onPressed: () {
            BlocProvider.of<MapaBloc>(context).add(OnShowRoute());
          },
        ),
      ),
    );
  }
}
