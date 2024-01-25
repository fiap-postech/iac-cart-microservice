resource "aws_sns_topic" "cart_closed_topic" {
  name                                  = local.sns.name
  firehose_success_feedback_sample_rate = 0
  http_success_feedback_sample_rate     = 0
  kms_master_key_id                     = local.sns.kms_master_key_id
  delivery_policy = jsonencode(
    {
      http : {
        defaultHealthyRetryPolicy : {
          minDelayTarget     = local.sns.min_delay_target,
          maxDelayTarget     = local.sns.max_delay_target,
          numRetries         = local.sns.num_retries,
          numMaxDelayRetries = local.sns.num_max_delay_retries,
          numNoDelayRetries  = local.sns.num_no_delay_retries,
          numMinDelayRetries = local.sns.num_min_delay_retries,
        },
        disableSubscriptionOverrides = local.sns.disable_subscription_overrides,
        defaultThrottlePolicy : {
          maxReceivesPerSecond = local.sns.max_receives_per_second
        }
      }
    }
  )
}