import 'package:flutter/material.dart';

class privacypolicydialog extends StatelessWidget {
  privacypolicydialog({Key? key}) : super(key: key);
  final String text =
      """Clients on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
                                                  nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
                                                  nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
                                                    nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
                                                    nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
                                                    nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
`                                                   Generally, we may collect and use personal information for many purposes, including, but not limited to: billing, product and service fulfillment, understanding customer needs, providing a better website, improving products and services, and communicating with customers and potential customers regarding our products and services with third-party products and services.""";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                wordSpacing: 3,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 12),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pop(context),
                },
                child: Text('اوافق'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
