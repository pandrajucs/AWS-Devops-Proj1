//TG attachment

resource "aws_lb_target_group_attachment" "tg1" {
  count=3
  target_group_arn = "${aws_lb_target_group.tg.arn}"
  target_id = "${element(aws_instance.servers.*.id,count.index)}"
  port             = 80
}

//NLB Listener

resource "aws_lb_listener" "web" {
  load_balancer_arn = "${aws_lb.nlb.arn}"
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }
}