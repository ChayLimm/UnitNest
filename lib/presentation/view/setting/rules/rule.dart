import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/domain/service/setting_service.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEditing = false;
  String rules = " ";
  

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context,settingProvider, child){

      return Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 70),
        child: Container(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Rules",style: UniTextStyles.heading,),
                subtitle: Text("Rules and policy for these building",style: UniTextStyles.body,),
                trailing: IconButton(icon: const Icon(Icons.edit), color: isEditing ?UniColor.iconLight : UniColor.primary,onPressed: (){
                  setState(() {
                    if(isEditing == false){
                      isEditing = true;
                    }
                  });
                },),
              ),
              const SizedBox(height: UniSpacing.xl,),

              Form(
                key: _formKey,
                child: buildTextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  enabled: isEditing,
                  initialValue: settingProvider.setting.rule,
                  onChanged: (value){
                    rules = value;
                  }, 
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Rules is required";
                    }else{
                      return null;
                    }
                  }
                  ),

              ),
              const SizedBox( height:UniSpacing.s),
                            Text("These rules will be displayed below every receipt.",style: UniTextStyles.body,),

              const SizedBox(height: UniSpacing.xl,),
              if(isEditing)... [Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UniButton(buttonType: ButtonType.secondary,context: context, label: "Cancel", trigger: (){
                    setState(() {
                      isEditing = false;
                    });
                  }),
                  const SizedBox(width: UniSpacing.s,),
                  UniButton(buttonType: ButtonType.primary,context: context, trigger: ()async{
                    if(_formKey.currentState!.validate())  {
                      settingProvider.updateRules(rules);
                      setState(() {
                          isEditing = false;
                      });
                      showCustomSnackBar(context, message: "Rules updated successfully", backgroundColor: UniColor.green);
                    }

                  }, label: "Save")
                ],
              ),
              const SizedBox(height: UniSpacing.xl,),],
            ],
          ),
        ),
      );
    });
  }
}