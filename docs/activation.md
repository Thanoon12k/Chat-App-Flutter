# تفعيل خدمات دردشة
من شاشة المحادثات، افتح رمز الدرع «إدارة التطبيق». يظهر بعد إكمال الملف الشخصي بالحساب المخوّل وبريد مؤكد. تبويبات الإدارة هي الغرف، الأعضاء والإعدادات. فتح الغرفة يعرض أعضاءها. تغيير حد الغرف يؤثر على الإنشاء القادم فقط.

## الهاتف
في مشروع Supabase المشترك جهّز Phone provider مع Twilio ومرسل WhatsApp معتمد، وفعل تأكيد الهاتف وحدود الإرسال. اختبر SMS وواتساب على ‎+964، محلياً ومع رقم جديد وحساب Google موجود. لا تستخدم التأكيد التلقائي. بعد تجهيز المزوّد:
```sql
update chat_private.settings set phone_login_enabled=true where id;
-- بعد اختبار القناتين وربط حساب قديم
update chat_private.settings set require_phone=true where id;
```

## الإشعارات
سجّل معرّفات Android وiOS في Firebase، وأضف google-services.json إلى android/app وGoogleService-Info.plist إلى Runner target، وارفع مفتاح APNs إلى Firebase وفعّل Push Notifications في Apple. ابنِ مع --dart-define=PUSH_ENABLED=true. ضع JSON حساب خدمة Firebase في سر Supabase باسم FCM_SERVICE_ACCOUNT. أنشئ CHAT_PUSH_WORKER_SECRET عشوائياً بطول 32 حرفاً على الأقل داخل Edge Secrets، وخزّن نفس القيمة في Vault تحت chat_push_worker. اضبط Supabase Cron ثم فعّل الإشعارات:
```sql
select cron.schedule('chat-push-worker','10 seconds',$job$
 select net.http_post(
   url := 'https://axncazensmjdqpczvzwf.supabase.co/functions/v1/chat-push',
   headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer ' ||
     (select decrypted_secret from vault.decrypted_secrets where name='chat_push_worker')),
   body := '{}'::jsonb)
 where exists(select 1 from public.chat_push_jobs where status='pending' and available_at<=now());
$job$);
select cron.schedule('chat-push-cleanup','10 3 * * *',$job$
 delete from public.chat_push_jobs where created_at<now()-interval '7 days';
$job$);
update chat_private.settings set push_enabled=true where id;
```
افحص وصول إشعار لغرفة فيها جهازان على الأقل، الخلفية وفتح الغرفة بعد الضغط والكتم والخروج من الحساب. الإرسال يشمل رسائل الغرفة ومنها الأسئلة.

## الاشتراك
أنشئ اشتراكاً دورياً في App Store Connect وحدد السعر والمدة، ثم اربطه في RevenueCat باستحقاق vip وعرض current. أضف REVENUECAT_SECRET_KEY (مفتاح REST v1) وREVENUECAT_WEBHOOK_SECRET إلى Edge Secrets. اجعل عنوان webhook ينتهي بـ /functions/v1/chat-vip-webhook ورأس Authorization يساوي Bearer ثم قيمة السر. اختر Keep with original App User ID للاستعادة. للاختبار فقط استخدم مشروعاً منفصلاً مع ALLOW_SANDBOX_VIP=true.
ابنِ iOS مع IOS_PURCHASES_ENABLED=true وREVENUECAT_APPLE_KEY وTERMS_URL وPRIVACY_URL عبر dart-define. اختبر الشراء والاستعادة والإلغاء، ثم فعّل حدود الغرف من الإدارة. اترك ANDROID_PURCHASES_ENABLED=false لملف التاجر العراقي الحالي. تحقق من أهلية المتجر قبل تفعيل مبيعات Android.
