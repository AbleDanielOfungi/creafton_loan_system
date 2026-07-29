import 'package:flutter/material.dart';

class KpiCard extends StatefulWidget {
  final String title;

  final String value;

  final IconData icon;

  final Color color;

  final String? subtitle;

  final String? trend;

  final bool positive;

  final VoidCallback? onTap;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trend,
    this.positive = true,
    this.onTap,
  });

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovering = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        transform: Matrix4.identity()
          ..translate(0.0, hovering ? -4.0 : 0.0),

        child: InkWell(
          borderRadius: BorderRadius.circular(18),

          onTap: widget.onTap,

          child: Card(
            elevation: hovering ? 10 : 3,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            child: Container(
              padding: const EdgeInsets.all(20),

              constraints: const BoxConstraints(
                minHeight: 165,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  //------------------------------------------------
                  // TOP
                  //------------------------------------------------

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color:
                              widget.color.withOpacity(.12),

                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: 30,
                        ),
                      ),

                      const Spacer(),

                      if (widget.trend != null)
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: widget.positive
                                ? Colors.green
                                    .withOpacity(.12)
                                : Colors.red
                                    .withOpacity(.12),

                            borderRadius:
                                BorderRadius.circular(30),
                          ),

                          child: Row(
                            children: [
                              Icon(
                                widget.positive
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                size: 16,
                                color: widget.positive
                                    ? Colors.green
                                    : Colors.red,
                              ),

                              const SizedBox(width: 4),

                              Text(
                                widget.trend!,
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  color: widget.positive
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const Spacer(),

                  //------------------------------------------------
                  // VALUE
                  //------------------------------------------------

                  Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),

                  const SizedBox(height: 10),

                  //------------------------------------------------
                  // TITLE
                  //------------------------------------------------

                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 6),

                    Text(
                      widget.subtitle!,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}