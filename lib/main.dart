import 'package:flutter/material.dart';
import 'package:football_manager/team.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Football Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final rnd = Random();

  List<Team> teamstats = [];

  @override
  void initState() {
    for (var teams in listandings) {
      var teamtemp = Team(
          id: int.parse(teams['id'].toString()),
          code: int.parse(teams['code'].toString()),
          name: teams['name'].toString(),
          played: int.parse(teams['played'].toString()),
          goals: int.parse(teams['goals'].toString()),
          fouls: int.parse(teams['fouls'].toString()),
          points: int.parse(teams['points'].toString()),
          W: int.parse(teams['W'].toString()),
          L: int.parse(teams['L'].toString()),
          D: int.parse(teams['D'].toString()));

      teamstats.add(teamtemp);
    }
    print(teamstats);

    super.initState();
  }

  int _currentSortColumn = 0;
  bool _isAscending = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(8.0),
                child: DataTable(
                  columnSpacing: 15.0,
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  border: TableBorder.all(color: Colors.black),
                  columns: [
                    DataColumn(label: Text('Team')),
                    DataColumn(label: Text('P')),
                    DataColumn(label: Text('G')),
                    DataColumn(label: Text('F')),
                    DataColumn(
                        label: Text('Pts'),
                        onSort: (columnindex, _) {
                          setState(() {
                            _currentSortColumn = columnindex;
                            if (_isAscending == true) {
                              _isAscending = false;
                              // sort the team standings list in Ascending, order by Points
                              teamstats.sort((teamA, teamB) =>
                                  teamB.points.compareTo(teamA.points));
                            } else {
                              _isAscending = true;
                              // sort the team standings list in Descending, order by Points
                              teamstats.sort((teamA, teamB) =>
                                  teamA.points.compareTo(teamB.points));
                            }
                          });
                        }),
                    DataColumn(label: Text('W')),
                    DataColumn(label: Text('L')),
                    DataColumn(label: Text('D')),
                  ],
                  rows: teamstats.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item.name.toString())),
                      DataCell(Text(item.played.toString())),
                      DataCell(Text(item.goals.toString())),
                      DataCell(Text(item.fouls.toString())),
                      DataCell(Text(item.points.toString())),
                      DataCell(Text(item.W.toString())),
                      DataCell(Text(item.L.toString())),
                      DataCell(Text(item.D.toString())),
                    ]);
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  int a = 0;
                  for (int i = 0; i < teamstats.length; i++) {
                    var teamplayed = teamstats[i];
                    print(teamstats.length);
                    var listwithoutplayedteam = teamstats
                        .where((x) => teamstats.indexOf(x) > i)
                        .toList();
                    print(listwithoutplayedteam);
                    if (listwithoutplayedteam.isNotEmpty) {
                      for (var enemy in listwithoutplayedteam) {
                        //LAMBDA
                        var teamCode = teamplayed.code /
                            (teamplayed.code + enemy.code) *
                            3.5;
                        var enemyCode =
                            enemy.code / (teamplayed.code + enemy.code) * 3;

                        var teamball = 0;
                        var enemyball = 0;

                        //VAR FOR BASED GENERATOR
                        double s = 0.0;
                        double k = 0.0;

                        //BASE GENERATOR
                        while (true) {
                          s += log(rnd.nextDouble());
                          if (s < -teamCode) {
                            break;
                          } else {
                            setState(() {
                              teamball++;
                            });
                          }
                        }
                        while (true) {
                          k += log(rnd.nextDouble());
                          if (k < -enemyCode) {
                            break;
                          } else {
                            setState(() {
                              enemyball++;
                            });
                          }
                        }

                        //DRAW GAME
                        if (teamball == enemyball) {
                          setState(() {
                            teamstats[i].goals += teamball;
                            teamstats[i].points += 1;
                            teamstats[i].played += 1;
                            teamstats[i].fouls += enemyball;
                            teamstats[i].D += 1;
                            var opp = teamstats.indexWhere(
                                (x) => teamstats.indexOf(x) == enemy.id - 1);
                            teamstats[opp].goals += enemyball;
                            teamstats[opp].fouls += teamball;
                            teamstats[opp].points += 1;
                            teamstats[opp].played += 1;
                            teamstats[opp].D += 1;
                          });

                          //ENEMY WIN
                        }
                        if (teamball < enemyball) {
                          setState(() {
                            teamstats[i].goals += teamball;
                            teamstats[i].played += 1;
                            teamstats[i].fouls += enemyball;
                            teamstats[i].L += 1;
                            var opp = teamstats.indexWhere(
                                (x) => teamstats.indexOf(x) == enemy.id - 1);
                            teamstats[opp].goals += enemyball;
                            teamstats[opp].fouls += teamball;
                            teamstats[opp].points += 3;
                            teamstats[opp].played += 1;
                            teamstats[opp].W += 1;
                          });

                          //TEAM WIN
                        }
                        if (teamball > enemyball) {
                          setState(() {
                            teamstats[i].goals += teamball;
                            teamstats[i].points += 3;
                            teamstats[i].played += 1;
                            teamstats[i].fouls += enemyball;
                            teamstats[i].W += 1;
                            var opp = teamstats.indexWhere(
                                (x) => teamstats.indexOf(x) == enemy.id - 1);
                            teamstats[opp].goals += enemyball;
                            teamstats[opp].fouls += teamball;
                            teamstats[opp].played += 1;
                            teamstats[opp].L += 1;
                          });
                        }
                      }
                    }
                  }
                },
                child: Container(
                  height: 60.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue),
                  child: const Center(
                    child: Text(
                      'SIMULATE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
