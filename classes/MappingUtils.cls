public with sharing class MappingUtils {

    private static Map<String,Set<String>> MAPPABLE_FIELD_CACHE = new Map<String,Set<String>>();    
    
    public static Set<String> getMappableFieldNames(Schema.SObjectType srcType, Schema.SObjectType destType) {
        String key = String.valueOf(srcType) + String.valueOf(destType);
        if (!MAPPABLE_FIELD_CACHE.containsKey(key)) {
            Set<String> names = new Set<String>();
            for (Schema.SObjectField srcField : MetaDataUtils.getFields(srcType)) {
                if (srcField.getDescribe().isCustom() && !isManagedField(srcField)) {
                    Schema.SObjectField destField = MetaDataUtils.getField(destType, srcField.getDescribe().getName());
                    if ((destField != null) && destField.getDescribe().isUpdateable() && isFieldMappable(srcField, destField)) {
                        names.add(srcField.getDescribe().getName());    
                    }
                }
            }
            MAPPABLE_FIELD_CACHE.put(key, names);
            return names;
        }
        return MAPPABLE_FIELD_CACHE.get(key);
    }
    
    private static Boolean isManagedField(Schema.SObjectField field) {
        return
            !field.getDescribe().getName().equalsIgnoreCase(field.getDescribe().getLocalName()) ||
            (/*(QuoteUtils.getDeveloperPrefix() == '') && */(!field.getDescribe().getName().toLowerCase().startsWith('custom') || field.getDescribe().getName().toLowerCase().equalsIgnoreCase('customerprice__c')));
    }  
    
    public static Boolean isFieldMappable(Schema.SObjectField field1, Schema.SObjectField field2) {
        if ((field1 == null) || (field2 == null) || (field1.getDescribe().getType() != field2.getDescribe().getType())) {
            return false;
        }
        if (field1.getDescribe().getType() == Schema.DisplayType.Reference) {
            return field1.getDescribe().getReferenceTo()[0] == field2.getDescribe().getReferenceTo()[0];
        }
        return true;
    }  
}